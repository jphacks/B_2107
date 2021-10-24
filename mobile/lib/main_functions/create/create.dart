import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/main_functions/room/creater/room.dart';

class CreateRoom extends StatefulWidget {
  @override
  CreateRoomState createState() => CreateRoomState();
}

class CreateRoomState extends State<CreateRoom> {
  bool _checkedInfinity = false;
  bool _checkedAnonymous = false;
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    var black = Colors.black;
    final default_image =
        "https://firebasestorage.googleapis.com/v0/b/summerhackathon2021-23986.appspot.com/o/user_icon%2Fdefault.png?alt=media&token=2e1a0e9f-41eb-41f8-8c2d-40467c5d6277";

    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CheckboxListTile(
            title: Text("無限いいね"),
            secondary: Icon(
              Icons.thumb_up_alt,
              color: _checkedInfinity ? Colors.blue : Colors.black,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: _checkedInfinity,
            onChanged: (bool newValue) {
              print(newValue);
              setState(() {
                _checkedInfinity = newValue;
              });
            },
            activeColor: Colors.blue,
            checkColor: Colors.green,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: CheckboxListTile(
            title: Text("匿名投票"),
            secondary: Icon(
              Icons.no_accounts,
              color: _checkedAnonymous ? Colors.blue : Colors.black,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: _checkedAnonymous,
            onChanged: (bool newValue) {
              setState(() {
                _checkedAnonymous = newValue;
              });
            },
            activeColor: Colors.blue,
            checkColor: Colors.black,
          ),
        ),
        //ルーム作成ボタン
        FloatingActionButton.extended(
            tooltip: "ルームを作成する",
            icon: Icon(Icons.add),
            label: Text("ルームを作成する"),
            onPressed: () async {
              //id
              var rands = new Random();
              var nexts = rands.nextDouble() * 100000000;

              while (nexts < 10000000) {
                nexts *= 10;
              }

              var room_id = nexts.toInt();
              //password
              var rand = new Random();
              var next = rand.nextDouble() * 10000;

              while (next < 1000) {
                next *= 10;
              }

              var numbers = next.toInt();
              //random関数
              //documentID
              var docRef = await _firestore.collection("mtg").add(
                {
                  "agenda": "未設定",
                  "uid": uid,
                  "users": "",
                  "room_id": room_id,
                  "password": numbers,
                  "infinity": _checkedInfinity,
                  "anonymous": _checkedAnonymous,
                },
              );
              var documentId = docRef.id;
              _firestore.collection("mtg").doc(documentId).update(
                {
                  "mtg_docID": documentId,
                  "users": FieldValue.arrayUnion([uid]),
                },
              );
              final userRef = FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', isEqualTo: uid);
              userRef.get().then(
                (snapshot) {
                  final List<String> name = [];
                  final List<String> image = [];
                  snapshot.docs.forEach((doc) {
                    name.add(doc.data()["name"]);
                    image.add(doc.data()["user_image"]);
                  });
                      if (_checkedAnonymous == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Room(documentId, "匿名",
                                  default_image, room_id, numbers,_checkedInfinity),
                            ));
                      } 
                      else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Room(documentId,
                                  name[0], image[0], room_id, numbers,_checkedInfinity),
                            ));
                      }
                   
                    
                  });
                },
              ),
            
      ])),
    );
  }
}
