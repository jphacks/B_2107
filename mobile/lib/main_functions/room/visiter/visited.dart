import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jphacks/main_functions/vote/vote.dart';

class Visited extends StatefulWidget {
  @override
  VisitedState createState() => VisitedState();
  Visited(this.docID, this.name, this.image, this.room_id, this.number, this.check);
  String docID;
  String name;
  String image;
  int room_id;
  int number;
  bool check;
}

class VisitedState extends State<Visited> {
  @override
  String _agenda = "";
  String _opinion = "";
  final _firestore = FirebaseFirestore.instance;
  @override
  //コメントを追加する関数
  Future<void> PostOpinion(BuildContext context) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text("戻る"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text("決定"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() async {
                        var docRef =
                            await _firestore.collection("opinions").add(
                          {
                            "opinion": _opinion,
                            "uid": uid,
                            "room_id": widget.room_id,
                            "opinion_good":
                                "", //create.dartから持ってくる(documentIDをidとする)
                            "vote": "",
                            "rank": "NOT",
                            "user_name": widget.name,
                            "user_image": widget.image,
                            "mtg_id": widget.docID,
                            "password": widget.number,
                            "datetime": DateTime.now(),
                            "vote_user":0,
                          },
                        );
                        var documentId = docRef.id;
                        _firestore
                            .collection("opinions")
                            .doc(documentId)
                            .update(
                          {"opinion_docID": documentId},
                        );
                      });
                    },
                  ),
                ],
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: TextFormField(
                  minLines: 6,
                  maxLines: 6,
                  onChanged: (String value) {
                    _opinion = value;
                  },
                  decoration: new InputDecoration(
                    //Focusしていないとき
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    //Focusしているとき
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '意見',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 25,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: <Widget>[],
        ),
        body: Center(
            child: Column(children: [
          //更新されたらすぐ反映する処理
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("mtg")
                .where("room_id", isEqualTo: widget.room_id)
                .where("password", isEqualTo: widget.number)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      //議題を表示する画面
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          children: [
                            //議題追加ボタン

                            Container(
                              margin: EdgeInsets.only(top: 10, right: 10),
                              width: double.infinity,
                              child: ListTile(
                                title: Text(
                                    "参加人数　" +
                                        document
                                            .data()['users']
                                            .length
                                            .toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    )),
                                leading: Container(
                                  child: IconButton(
                                    icon: Icon(Icons.edit_sharp),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                            //議題
                            Container(
                              margin: EdgeInsets.only(top: 60, bottom: 60),
                              width: double.infinity,
                              child: Text(
                                document.data()['agenda'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            //意見
                            Container(
                                margin: EdgeInsets.only(left: 8),
                                child: ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: IconButton(
                                      icon: Icon(Icons.post_add_outlined),
                                      onPressed: () {
                                        PostOpinion(context);
                                        print(widget.docID);
                                      },
                                    )),
                                    Container(
                                        child: IconButton(
                                      icon: Icon(Icons.how_to_vote),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('確認'),
                                              content: Text('投票を始めますか？'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text("投票を始める"),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Vote(
                                                                      widget
                                                                          .docID,
                                                                      widget
                                                                          .name,
                                                                      widget
                                                                          .image,
                                                                          "visiter")));
                                                    }),
                                                FlatButton(
                                                    child: Text("いいえ"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    )),
                                  ],
                                )),
                          ],
                        ),
                      ));
                }).toList(),
              );
            },
          ),
          //意見を表示させる
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("opinions")
                  .where("mtg_id", isEqualTo: widget.docID)
                  .orderBy('datetime', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    //リプライ部分
                    return Container(
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 26.0,
                                      backgroundImage: NetworkImage(
                                          document.data()['user_image']),
                                      backgroundColor: Colors.white,
                                    ),
                                    title: Text(document.data()['user_name'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 15, bottom: 20, left: 90, right: 15),
                                  width: double.infinity,
                                  child: Text(
                                    document.data()['opinion'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 19),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 200),
                                    child: IconButton(
                                        icon: const Icon(Icons.favorite_border),
                                        color: Colors.red,
                                        onPressed: () async {
                                          // データを更新
                                       var count = 1;
                                          var countgood=count+document.data()["opinion_good"].length;
                                          if(widget.check==true){
                                              _firestore
                                              .collection("opinions")
                                              .doc(document
                                                  .data()["opinion_docID"])
                                              .update(
                                            {
                                              "opinion_good":
                                                  FieldValue.arrayUnion([countgood]),
                                            },
                                          );
                                          }
                                          else{
                                              _firestore
                                              .collection("opinions")
                                              .doc(document
                                                  .data()["opinion_docID"])
                                              .update(
                                            {
                                              "opinion_good":
                                                  FieldValue.arrayUnion([uid]),
                                            },
                                          );
                                          }
                                        }),
                                  ),
                                  //いいね数表示
                                  Text((document.data()["opinion_good"].length)
                                      .toString()),
                                ])
                              ],
                            )));
                  }).toList(),
                );
              },
            ),
          ),
        ])));
  }
}
