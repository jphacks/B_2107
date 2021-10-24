import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/login/model/vote_model.dart';
import 'package:jphacks/main_functions/result/result.dart';
import 'package:provider/provider.dart';

class WaitingVote extends StatefulWidget {
  @override
  WaitingVoteState createState() => WaitingVoteState();
  WaitingVote(this.docID);
  final docID;
}

class WaitingVoteState extends State<WaitingVote> {
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return ChangeNotifierProvider<VoteModel>(
        create: (_) => VoteModel(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: <Widget>[],
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(),
                  ),
                  ListTile(
                    title: Text('終了する'),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: Consumer<VoteModel>(builder: (context, model, child) {
              return Center(
                  child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 20, right: 290, bottom: 10),
                  child: Text("投票者一覧",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      )),
                ),
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("opinions")
                        .where("mtg_id", isEqualTo: widget.docID)
                        .where("vote", isEqualTo: "true")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
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
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 26.0,
                                            backgroundImage: NetworkImage(
                                                document.data()['user_image']),
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Text(
                                              document.data()['user_name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17)),
                                        ),
                                      ),
                                    ],
                                  )));
                        }).toList(),
                      );
                    },
                  ),
                ),
                SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('投票を締め切る'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            primary: Colors.pink[600],
                            onPrimary: Colors.white70,
                            elevation: 5,
                          ),
                          onPressed: () async {
                            final userRef = FirebaseFirestore.instance
                                .collection('opinions')
                                .where('mtg_id', isEqualTo: widget.docID)
                                .where('vote_user', isGreaterThanOrEqualTo: 1)
                                .orderBy('vote_user', descending: true);
                            userRef.get().then(
                              (snapshot) {
                                final List<String> docIDs = [];
                                final List<int> total = [];
                                snapshot.docs.forEach((doc) {
                                  docIDs.add(doc.data()["opinion_docID"]);
                                  total.add(doc.data()["vote_user"]);
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Result(docIDs,total,widget.docID),
                                    ));
                                model.changes = widget.docID;
                                model.change();
                              },
                            );
                          }),
                    ),
                  ],
                ))
              ]));
            })));
  }
}
