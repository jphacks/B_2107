import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/main_functions/room/visiter/visited.dart';


class Join extends StatefulWidget {
  @override
  JoinState createState() => JoinState();
}

class JoinState extends State<Join> {
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    var black = Colors.black;
    TextEditingController room_ids = TextEditingController();
    TextEditingController room_password = TextEditingController();
    String room_id = "";
    String password = "";
    final default_name = "匿名";
    final default_image =
        "https://firebasestorage.googleapis.com/v0/b/summerhackathon2021-23986.appspot.com/o/user_icon%2Fdefault.png?alt=media&token=2e1a0e9f-41eb-41f8-8c2d-40467c5d6277";
    List<String> names = [];
    List<String> images = [];
    List<bool> check = [];

    Future getName() async {
      setState(() {
        final userRef = FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: uid);
        userRef.get().then(
          (snapshot) {
            final List<String> name = [];
            final List<String> image = [];
            snapshot.docs.forEach((doc) {
              names.add(doc.data()["name"]);
            });
            snapshot.docs.forEach((doc) {
              images.add(doc.data()["user_image"]);
            });
            names.add(name[0]);
            images.add(image[0]);
          },
        );
      });
    }

    Future getSetting() async {
      setState(() {
        final userRef = FirebaseFirestore.instance
            .collection('mtg')
            .where("room_id", isEqualTo: int.parse(room_ids.text));
        userRef.get().then(
          (snapshot) {
            snapshot.docs.forEach((doc) {
              check.add(doc.data()["anonymous"]);
              check.add(doc.data()["infinity"]);
            });
          },
        );
      });
    }

    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        //ルーム作成ボタン
        Container(
          margin: EdgeInsets.only(top: 450, bottom: 30, left: 30, right: 30),
          child: TextFormField(
            onChanged: (String value) {
              room_ids.text = value;
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
              hintText: 'Room_id',
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
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
          child: TextFormField(
            onChanged: (String value) {
              room_password.text = value;
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
              hintText: 'password',
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

        FloatingActionButton.extended(
            tooltip: "ルームを作成する",
            icon: Icon(Icons.add),
            label: Text("ルームを参加する"),
            onPressed: () async {
              getName();
              getSetting();
              final userRefs = FirebaseFirestore.instance
                  .collection('mtg')
                  .where('room_id', isEqualTo: int.parse(room_ids.text));
              userRefs.get().then(
                (snapshot) {
                  final List<String> ids = [];
                  snapshot.docs.forEach((doc) {
                    ids.add(doc.data()["mtg_docID"]);
                  });
                  _firestore.collection("mtg").doc(ids[0]).update(
                {
                  "users": FieldValue.arrayUnion([uid]),
                },
              );
                  
                    if (check[0] == true) {
                      print(check[0]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Visited(
                                ids[0],
                                default_name,
                                default_image,
                                int.parse(room_ids.text),
                                int.parse(room_password.text),
                                check[1])),
                          );
                    } 
                    else{
                      print(check[0]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Visited(
                                ids[0],
                                names[0],
                                images[0],
                                int.parse(room_ids.text),
                                int.parse(room_password.text),
                                check[1]),
                          ));
                    }
                },
              );
            }),
      ])),
    );
  }
}
