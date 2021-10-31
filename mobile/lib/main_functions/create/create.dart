import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/animation/fade-animation.dart';
import 'package:jphacks/main_functions/room/creater/room.dart';
import 'package:meta/meta.dart';
import 'package:jphacks/animation/fade-animation.dart';
import 'package:jphacks/login/model/create_model.dart';
import 'package:jphacks/login/model/timepicker.dart';
import 'package:jphacks/main_functions/room/creater/room.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  @override
  CreateRoomState createState() => CreateRoomState();
}

class CreateRoomState extends State<CreateRoom> {
  bool _checkedInfinity = false;
  bool _checkedAnonymous = false;
  bool _timer = false;
  bool isHovered = true;
  final times = ["未設定"];
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    var black = Colors.black;

    final default_image =
        "https://firebasestorage.googleapis.com/v0/b/summerhackathon2021-23986.appspot.com/o/user_icon%2Fdefault.png?alt=media&token=2e1a0e9f-41eb-41f8-8c2d-40467c5d6277";
    String questions_genre;
    String _select = "未設定";

    void _onSelectedItemChanged(int index) {
      setState(() {
        _select = timer[index];
      });
    }

    void picker_genre() {
      Widget _pickerGenre(String str) {
        return Text(
          str,
          style: const TextStyle(fontSize: 20),
        );
      }

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
                        setState(() {
                          times.removeAt(0);
                          times.add(_select);
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    children: timer.map(_pickerGenre).toList(),
                    onSelectedItemChanged: _onSelectedItemChanged,
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //head画像
              Container(
                margin: const EdgeInsets.only(top: 100),
                width: 100,
                height: 100,
                child: Image.asset("lib/images/Logo_head.png"),
              ),
              //name画像
              Container(
                margin: const EdgeInsets.only(top: 100),
                width: 200,
                height: 150,
                child: Image.asset("lib/images/Logo_name.png"),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(top: 20, right: 18, left: 18),
                child: FadeAnimation(
                  2,
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 25,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.green,
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        "無限いいね",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      secondary: Icon(
                        Icons.thumb_up_alt,
                        color: _checkedInfinity ? Colors.black : Colors.white,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checkedInfinity,
                      onChanged: (bool newValue) {
                        print(newValue);
                        setState(() {
                          _checkedInfinity = newValue;
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(right: 20.5, left: 20.5),
            child: FadeAnimation(
              2.33,
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 25,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.green,
                ),
                child: CheckboxListTile(
                  title: Text(
                    "匿名投票",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  secondary: Icon(
                    Icons.no_accounts,
                    color: _checkedAnonymous ? Colors.black : Colors.white,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _checkedAnonymous,
                  onChanged: (bool newValue) {
                    setState(() {
                      _checkedAnonymous = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(right: 21.5, left: 21.5),
            child: FadeAnimation(
              2.50,
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 25,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.green,
                ),
                child: CheckboxListTile(
                  title: Text(
                    "時間設定",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  secondary: Icon(
                    Icons.access_alarm_sharp,
                    color: _timer ? Colors.black : Colors.white,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _timer,
                  onChanged: (bool newValue) {
                    setState(() {
                      _timer = newValue;
                    });
                    if (_timer == true) {
                      picker_genre();
                    }
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
              ),
            ),
          ),
          //ルーム作成ボタン
          Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: FadeAnimation(
                2.60,
                ElevatedButton(
                  child: const Text("ルームを作成する"),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 22.5),
                    fixedSize: const Size(275, 75),
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    elevation: 50,
                    //ボタン角丸
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
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
                    userRef.get().then((snapshot) {
                      final List<String> name = [];
                      final List<String> image = [];
                      snapshot.docs.forEach((doc) {
                        name.add(doc.data()["name"]);
                        image.add(doc.data()["user_image"]);
                      });
                      if (_checkedAnonymous == true) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Room(
                                    documentId,
                                    "匿名",
                                    default_image,
                                    room_id,
                                    numbers,
                                    _checkedInfinity,
                                    times[0])),
                            (_) => false);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Room(
                                    documentId,
                                    name[0],
                                    image[0],
                                    room_id,
                                    numbers,
                                    _checkedInfinity,
                                    times[0])),
                            (_) => false);
                      }
                    });
                  },
                ),
              ))
        ])));
  }
}
