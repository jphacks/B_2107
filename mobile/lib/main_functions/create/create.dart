import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    String _select="未設定";

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
//picker_genre

//picker_major

    return ChangeNotifierProvider<CreateModel>(
        create: (_) => CreateModel(),
        child: MaterialApp(
            home: Consumer<CreateModel>(builder: (context, model, child) {
          return Stack(children: [
            //背景画像
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image:
                    AssetImage("lib/images/chris-lee-70l1tDAI6rM-unsplash.jpg"),
                fit: BoxFit.cover,
              )),
            ),
            Scaffold(
              backgroundColor: Colors.green.withOpacity(0.8),
              resizeToAvoidBottomInset: false,
              body: Container(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    margin: const EdgeInsets.only(top: 200),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                      ),
                      child: CheckboxListTile(
                        title: Text("無限いいね"),
                        secondary: Icon(
                          Icons.thumb_up_alt,
                          color: _checkedInfinity ? Colors.green : Colors.black,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checkedInfinity,
                        onChanged: (bool newValue) {
                          print(newValue);
                          setState(() {
                            _checkedInfinity = newValue;
                          });
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      child: CheckboxListTile(
                        title: Text("匿名投票"),
                        secondary: Icon(
                          Icons.no_accounts,
                          color:
                              _checkedAnonymous ? Colors.green : Colors.black,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checkedAnonymous,
                        onChanged: (bool newValue) {
                          setState(() {
                            _checkedAnonymous = newValue;
                          });
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      child: CheckboxListTile(
                        title: Text("会議時間"),
                        secondary: Icon(
                          Icons.no_accounts,
                          color: _timer ? Colors.green : Colors.black,
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
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    ),
                  ),
                  //ルーム作成ボタン
                  Container(
                    margin: const EdgeInsets.only(top: 80.0),
                    child: ElevatedButton(
                      child: const Text("ルームを作成する"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        elevation: 50,
                        side: BorderSide(
                          color: Colors.white, //枠線!
                          width: 1.25, //枠線！
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room(
                                      documentId,
                                      "匿名",
                                      default_image,
                                      room_id,
                                      numbers,
                                      _checkedInfinity,
                                      times[0]),
                                ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room(
                                      documentId,
                                      name[0],
                                      image[0],
                                      room_id,
                                      numbers,
                                      _checkedInfinity,
                                      times[0]),
                                ));
                          }
                        });
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ]);
        })));
  }
}
