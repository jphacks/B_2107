import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jphacks/main_functions/vote/vote.dart';
import 'dart:async';

class Room extends StatefulWidget {
  @override
  RoomState createState() => RoomState();
  Room(this.docID, this.name, this.image, this.room_id, this.number, this.check, this.timer);

  final docID;
  final name;
  final image;
  final room_id;
  final number;
  final check;
  final timer;
}

class RoomState extends State<Room> {
  @override
  String _agenda = "";
  String _opinion = "";
  String _time = '';
  final _firestore = FirebaseFirestore.instance;
  @override
  void dialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("終了時間になりました"),
          content: Text("投票を行ってください"),
          actions: <Widget>[
            // ボタン領
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void initState() {
    super.initState();
    if (widget.timer == "未設定") {
    } else {
      final pos = widget.timer.length - 1;
      final result = widget.timer.substring(0, pos);
      Future.delayed(Duration(seconds: int.parse(result) * 60), () {
        dialog();
      });
    }
  }

  //議題を変更する関数
  Future<void> UpdateAgenda(BuildContext context) async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.green[50],
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CupertinoButton(
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Text(
                          "戻る",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    CupertinoButton(
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Text(
                        "議題を変更",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _firestore.collection("mtg").doc(widget.docID).update(
                            {
                              "agenda": _agenda,
                            },
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: TextFormField(
                  minLines: 6,
                  maxLines: 6,
                  onChanged: (String value) {
                    _agenda = value;
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
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '議題',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[900],
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

  //コメントを追加する関数
  Future<void> PostOpinion(BuildContext context) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.green[50].withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CupertinoButton(
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Text(
                          "戻る",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    CupertinoButton(
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Text(
                          "コメントを追加",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          var docRef = await _firestore.collection("opinions").add(
                            {
                              "opinion": _opinion,
                              "uid": uid,
                              "room_id": widget.room_id,
                              "opinion_good": "", //create.dartから持ってくる(documentIDをidとする)
                              "vote": "",
                              "rank": "NOT",
                              "user_name": widget.name,
                              "user_image": widget.image,
                              "mtg_id": widget.docID,
                              "password": widget.number,
                              "datetime": DateTime.now(),
                              "vote_user": 0,
                            },
                          );
                          var documentId = docRef.id;
                          _firestore.collection("opinions").doc(documentId).update(
                            {"opinion_docID": documentId},
                          );
                        }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '意見を記入',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[900],
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

  Future<void> initAct(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("Roomの情報"),
          content: Text("Room_id: ${widget.room_id}\nPassWord: ${widget.number}"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text("クリップボードにコピー"),
                onPressed: () async {
                  final data = ClipboardData(text: "Room_id: ${widget.room_id}\nPassWord: ${widget.number}");
                  await Clipboard.setData(data);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text("戻る"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
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
          backgroundColor: Colors.green[50],
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  initAct(context);
                },
                child: Text(
                  '招待',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                )),
          ],
          elevation: 0.0,
        ),
        backgroundColor: Colors.green[50],
        body: Center(
            child: Column(children: [
          //更新されたらすぐ反映する処理
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("mtg").where("room_id", isEqualTo: widget.room_id).where("password", isEqualTo: widget.number).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        color: Colors.green[300],
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          children: [
                            //議題追加ボタン

                            Container(
                              margin: EdgeInsets.only(top: 10, right: 10),
                              width: double.infinity,
                              child: ListTile(
                                title: Container(
                                  margin: EdgeInsets.only(left: 80),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      "参加人数　" + document.data()['users'].length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green[200], width: 3.0),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green[700],
                                  ),
                                ),
                                leading: Container(
                                  child: IconButton(
                                    icon: Icon(Icons.edit_sharp),
                                    onPressed: () {
                                      UpdateAgenda(context);
                                    },
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
                                style: TextStyle(color: Colors.white, fontSize: 23),
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
                                              // title: Text('確認'),
                                              backgroundColor: Colors.green[50],
                                              content: Text('投票を始めますか？'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.green,
                                                      onPrimary: Colors.white,
                                                    ),
                                                    child: Text("投票を始める"),
                                                    onPressed: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Vote(widget.docID, widget.name, widget.image, document.data()['uid'])));
                                                    }),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.green,
                                                      onPrimary: Colors.white,
                                                    ),
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
              stream: FirebaseFirestore.instance.collection("opinions").where("mtg_id", isEqualTo: widget.docID).orderBy('datetime', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            color: Colors.green[400],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage: NetworkImage(document.data()['user_image']),
                                      backgroundColor: Colors.green[100],
                                    ),
                                    title: Text(document.data()['user_name'], style: TextStyle(color: Colors.black, fontSize: 17)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 90, right: 15),
                                  width: double.infinity,
                                  child: Text(
                                    document.data()['opinion'],
                                    style: TextStyle(color: Colors.black, fontSize: 19),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 200),
                                    child: IconButton(
                                        icon: const Icon(Icons.favorite_border),
                                        color: Colors.redAccent,
                                        onPressed: () async {
                                          // データを更新
                                          var count = 1;

                                          var countgood = count + document.data()["opinion_good"].length;
                                          if (widget.check == true) {
                                            _firestore.collection("opinions").doc(document.data()["opinion_docID"]).update(
                                              {
                                                "opinion_good": FieldValue.arrayUnion([countgood]),
                                              },
                                            );
                                          } else {
                                            _firestore.collection("opinions").doc(document.data()["opinion_docID"]).update(
                                              {
                                                "opinion_good": FieldValue.arrayUnion([uid]),
                                              },
                                            );
                                          }
                                        }),
                                  ),
                                  //いいね数表示
                                  Text((document.data()["opinion_good"].length).toString()),
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
