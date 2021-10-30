import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/main_functions/vote/visitedvote.dart';
import 'package:jphacks/main_functions/vote/waiting_vote.dart';

class Vote extends StatefulWidget {
  @override
  VoteState createState() => VoteState();
  Vote(this.docID, this.name, this.image, this.uid);
  final docID;
  final name;
  final image;
  final uid;
}

class VoteState extends State<Vote> {
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return Scaffold(
        backgroundColor: Colors.green[50],
        body: Center(
            child: Column(children: [
          SizedBox(
            height: 70,
          ),
          Container(
            width: 100,
            height: 50,
            margin: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                '投票',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.green[400],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("opinions").where("mtg_id", isEqualTo: widget.docID).snapshots(),
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
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.green[50],
                                    title: Text('確認'),
                                    content: Text('この意見に投票しますか'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            onPrimary: Colors.white,
                                          ),
                                          child: Text("いいえ"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            onPrimary: Colors.white,
                                          ),
                                          child: Text("投票"),
                                          onPressed: () async {
                                            final voteid = await _firestore
                                                .collection("vote")
                                                .add({"uid": uid, "mtg_id": widget.docID, "user_name": widget.name, "user_image": widget.image, "opinion_docID": document.data()["opinion_docID"]});
                                            final documentID = voteid.id;
                                            _firestore.collection("vote").doc(documentID).update(
                                              {"documentID": documentID},
                                            );
                                            var count = 1 + document.data()["vote_user"];
                                            _firestore.collection("opinions").doc(document.data()["opinion_docID"]).update(
                                              {
                                                "vote": "true",
                                                "vote_user": count,
                                              },
                                            );

                                            final userRef = FirebaseFirestore.instance.collection('mtg').where('mtg_docID', isEqualTo: widget.docID);
                                            userRef.get().then((snapshot) {
                                              final List<String> uids = [];
                                              snapshot.docs.forEach((doc) {
                                                uids.add(doc.data()["uid"]);
                                              });
                                              if (uid == uids[0]) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WaitingVote(widget.docID)));
                                              } else {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => VisitedVote(widget.docID)));
                                              }
                                            });
                                          })
                                    ],
                                  );
                                },
                              );
                            },
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
                                      margin: EdgeInsets.only(top: 5, bottom: 13, left: 90, right: 15),
                                      width: double.infinity,
                                      child: Text(
                                        document.data()['opinion'],
                                        style: TextStyle(color: Colors.black, fontSize: 19),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ))));
                  }).toList(),
                );
              },
            ),
          ),
        ])));
  }
}
