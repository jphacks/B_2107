import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Result extends StatefulWidget {
  @override
  ResultState createState() => ResultState();
  Result(this.docIDs, this.total, this.mtg_id);
  final docIDs;
  final total;
  final mtg_id;
}

class ResultState extends State<Result> {
  @override
  List<charts.Series<Ideas, String>> _seriesBarData;

  _generateData() {
    var barData = [
      new Ideas("A案　${widget.total[0]}票", widget.total[0],
          Color.fromRGBO(255, 110, 0, 1))
    ];
    if (widget.total.length == 2) {
      barData.add(new Ideas(
          'B案　${widget.total[1]}票', widget.total[1], Color(0xFFFFFFFF)));
    } else if (widget.total.length == 3) {
      barData.add(new Ideas(
          'B案　${widget.total[1]}票', widget.total[1], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'C案　${widget.total[2]}票', widget.total[2], Color(0xFFFFFFFF)));
    } else if (widget.total.length == 4) {
      barData.add(new Ideas(
          'B案　${widget.total[1]}票', widget.total[1], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'C案　${widget.total[2]}票', widget.total[2], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'D案　${widget.total[3]}票', widget.total[3], Color(0xFFFFFFFF)));
    } else if (widget.total.length == 5) {
      barData.add(new Ideas(
          'B案　${widget.total[1]}票', widget.total[1], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'C案　${widget.total[2]}票', widget.total[2], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'D案　${widget.total[3]}票', widget.total[3], Color(0xFFFFFFFF)));
      barData.add(new Ideas(
          'E案　${widget.total[4]}票', widget.total[4], Color(0xFFFFFFFF)));
    }

    _seriesBarData.add(
      charts.Series(
          data: barData,
          domainFn: (Ideas ideas, _) => ideas.ideas,
          measureFn: (Ideas ideas, _) => ideas.likes,
          colorFn: (Ideas ideas, _) =>
              charts.ColorUtil.fromDartColor(ideas.colorval),
          id: 'Ideas'),
    );
  }

  List<String> title = ["A", "B", "C", "D", "E"];

  Future setTitle() async {
    setState(() {
      final _firestore = FirebaseFirestore.instance;
      if (widget.docIDs.length == 5) {
        _firestore.collection("opinions").doc(widget.docIDs[0]).update(
          {
            "rank": "A案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[1]).update(
          {
            "rank": "B案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[2]).update(
          {
            "rank": "C案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[3]).update(
          {
            "rank": "D案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[4]).update(
          {
            "rank": "E案",
          },
        );
      } else if (widget.docIDs.length == 4) {
        _firestore.collection("opinions").doc(widget.docIDs[0]).update(
          {
            "rank": "A案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[1]).update(
          {
            "rank": "B案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[2]).update(
          {
            "rank": "C案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[3]).update(
          {
            "rank": "D案",
          },
        );
      } else if (widget.docIDs.length == 3) {
        _firestore.collection("opinions").doc(widget.docIDs[0]).update(
          {
            "rank": "A案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[1]).update(
          {
            "rank": "B案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[2]).update(
          {
            "rank": "C案",
          },
        );
      } else if (widget.docIDs.length == 2) {
        _firestore.collection("opinions").doc(widget.docIDs[0]).update(
          {
            "rank": "A案",
          },
        );
        _firestore.collection("opinions").doc(widget.docIDs[1]).update(
          {
            "rank": "B案",
          },
        );
      } else if (widget.docIDs.length == 1) {
        _firestore.collection("opinions").doc(widget.docIDs[0]).update(
          {
            "rank": "A案",
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    setTitle();
    // ignore: deprecated_member_use
    _seriesBarData = List<charts.Series<Ideas, String>>();
    _generateData();
  }

  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    final List<String> joins = [];
    final List<int> joinbest = [];
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green[50],
          actions: <Widget>[
            TextButton(
                onPressed: () {
                   showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("会議を保存しますか"),
                      content: Text("会議は３件まで保存可能です"),
                      actions: [
                        FlatButton(
                            child: Text("保存しない"),
                            onPressed: () {
                              final userRef = FirebaseFirestore.instance
                                  .collection('opinions')
                                  .where('mtg_id', isEqualTo: widget.mtg_id);
                              userRef.get().then((snapshot) {
                                final List<String> docIDs = [];
                                snapshot.docs.forEach((doc) {
                                  docIDs.add(doc.data()["opinion_docID"]);
                                });
                                for (var i = 0; i < docIDs.length; i++) {
                                  _firestore
                                      .collection("opinions")
                                      .doc(docIDs[i])
                                      .delete();
                                }
                              });
                              final use = FirebaseFirestore.instance
                                  .collection('mtg')
                                  .where('mtg_docID', isEqualTo: widget.mtg_id);
                              use.get().then((snapshot) {
                                final List<String> mtgIDs = [];
                                snapshot.docs.forEach((doc) {
                                  mtgIDs.add(doc.data()["mtg_docID"]);
                                });
                                for (var k = 0; k < mtgIDs.length; k++) {
                                  _firestore
                                      .collection("mtg")
                                      .doc(mtgIDs[k])
                                      .delete();
                                }
                              });
                              final votes = FirebaseFirestore.instance
                                  .collection('vote')
                                  .where('mtg_id', isEqualTo: widget.mtg_id);
                              votes.get().then((snapshot) {
                                final List<String> voteIDs = [];
                                snapshot.docs.forEach((doc) {
                                  voteIDs.add(doc.data()["documentID"]);
                                });
                                for (var w = 0; w < voteIDs.length; w++) {
                                  _firestore
                                      .collection("vote")
                                      .doc(voteIDs[w])
                                      .delete();
                                }
                              });
                              final user = FirebaseFirestore.instance
                                  .collection('user')
                                  .where('uid', isEqualTo: uid);
                              user.get().then((snapshot) {
                                final List<int> joincount = [];
                                snapshot.docs.forEach((doc) {
                                  joincount.add(doc.data()["join"]);
                                  joins.add(doc.data()["documentID"]);
                                  joinbest.add(doc.data()["best"]);
                                });
                                _firestore
                                    .collection("user")
                                    .doc(joins[0])
                                    .update(
                                  {
                                    "join": 1 + joincount[0],
                                  },
                                );
                              });
                              final best = FirebaseFirestore.instance
                                  .collection('opinions')
                                  .where('opinion_docID',
                                      isEqualTo: widget.docIDs[0]);
                              user.get().then((snapshot) {
                                final List<String> uids = [];
                                snapshot.docs.forEach((doc) {
                                  uids.add(doc.data()["uid"]);
                                });
                                if (uid == uids[0]) {
                                  _firestore
                                      .collection("user")
                                      .doc(joins[0])
                                      .update(
                                    {
                                      "best": 1 + joinbest[0],
                                    },
                                  );
                                }
                              });
                              Navigator.popUntil(context,
                                  (Route<dynamic> route) => route.isFirst);
                            }),
                        FlatButton(
                            child: Text("保存する"),
                            onPressed: () {
                              Navigator.popUntil(context,
                                  (Route<dynamic> route) => route.isFirst);
                            }),
                      ],
                    );
                  },
                );
                },
                child: Text(
                  '終了',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                )),
          ],
          elevation: 0.0,
        ),
      body: Center(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 30, right: 30, bottom: 10, left: 30),
            child: Container(
                padding: const EdgeInsets.all(30),
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(111, 172, 22, 1),
                  borderRadius: BorderRadius.circular(60),
                ),
                alignment: Alignment.center,
                child: new charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                  defaultRenderer: new charts.BarRendererConfig(
                      cornerStrategy: const charts.ConstCornerStrategy(12)),
                  domainAxis: charts.OrdinalAxisSpec(
                    showAxisLine: false,
                    renderSpec: new charts.SmallTickRendererSpec(
                      labelStyle: new charts.TextStyleSpec(
                        color: charts.MaterialPalette.white,
                      ),
                    ),
                  ),
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                ))),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("opinions")
                .where("mtg_id", isEqualTo: widget.mtg_id)
                .where("rank", whereIn: ["A案", "B案", "C案", "D案", "E案"])
                .orderBy('vote_user', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        color: Colors.green,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(children: [
                          ListTile(
                            title: Text(
                                document.data()['rank'] +
                                    " " +
                                    document.data()['opinion'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ]),
                      ));
                }).toList(),
              );
            },
          ),
        ),
      ])),
    );
  }
}

// データ
class Ideas {
  final String ideas;
  final int likes;
  final Color colorval;

  Ideas(this.ideas, this.likes, this.colorval);
}
