import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jphacks/login/animation.dart';
import '../main.dart';
import 'package:flutter/animation.dart';

import 'dart:math' as math;

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return 64 * math.sin(2 * math.pi * t);
  }
}

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  // Firebase 認証
  final _auth = FirebaseAuth.instance;
  UserCredential _result;
  User _user;
  String _login_name = "匿名";

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return MaterialApp(
      home: Stack(children: [
        //画像挿入
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
                'lib/images/blake-verdoorn-cssvEZacHvQ-unsplash (4).jpg'),
            fit: BoxFit.cover,
          )),
        ),
        Scaffold(
          //画像透過
          backgroundColor: Colors.green.withOpacity(0.9),
          resizeToAvoidBottomInset: false,
          body: Container(
              child: Column(children: [
            FadeAnimation(
              1.5,
              Container(
                margin:
                    EdgeInsets.only(top: 200, bottom: 30, left: 30, right: 30),
                child: Image(
                  image: AssetImage('lib/images/Logo_name_2.png'),
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
            //ご挨拶
            FadeAnimation(
              1.5,
              Container(
                margin:
                    EdgeInsets.only(top: 0, bottom: 30, left: 30, right: 30),
                child: Text(
                  "ビビスタへようこそ。",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //名前入力
            FadeAnimation(
              2,
              Container(
                margin:
                    EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
                child: TextFormField(
                  onChanged: (String value) {
                    _login_name = value;
                  },
                  decoration: new InputDecoration(
                    //Focusしていないとき
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0),
                      ),
                    ),
                    //Focusしているとき
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.7),
                        width: 2.0,
                      ),
                    ),
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    hintText: 'name',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 25,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            //初期登録
            FadeAnimation(
              2.5,
              Container(
                margin:
                    EdgeInsets.only(top: 0, bottom: 30, left: 30, right: 30),
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('名前を登録する'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    primary: Colors.green.withOpacity(0.8),
                    onPrimary: Colors.white,
                    elevation: 20.0,
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signInAnonymously();
                    final User user = await FirebaseAuth.instance.currentUser;
                    final String uid = user.uid.toString();
                    //ページ遷移
                    final _firestore = FirebaseFirestore.instance;
                    var docRef = await _firestore.collection("user").add(
                      {
                        "name": _login_name,
                        "uid": uid,
                        "user_image":
                            "https://firebasestorage.googleapis.com/v0/b/summerhackathon2021-23986.appspot.com/o/user_icon%2Fdefault.png?alt=media&token=2e1a0e9f-41eb-41f8-8c2d-40467c5d6277",
                        "join":0,
                        "best":0,
                      },
                    );
                    var documentId = docRef.id;
                    _firestore.collection("user").doc(documentId).update(
                      {"documentID": documentId},
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
              ),
            ),
            //注意書き
            FadeAnimation(
              2.5,
              Container(
                margin:
                    EdgeInsets.only(top: 0, bottom: 30, left: 30, right: 30),
                child: Text(
                  "未入力の場合: 匿名と登録されます。\n後からでも変更もできます。",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ])),
        ),
      ]),
    );
  }
}
