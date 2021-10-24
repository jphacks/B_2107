import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomSpace),
              child: Container(
                  child: Column(children: [
                //名前入力
                Container(
                  margin: EdgeInsets.only(
                      top: 470, bottom: 30, left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (String value) {
                      _login_name = value;
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
                      hintText: 'name',
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
                
                //注意書き
                Container(
                  margin:
                      EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                  child: Text(
                    "未入力の場合: 匿名と登録されます。\n後からでも変更もできます。",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),

                //初期登録
                Container(
                  margin:
                      EdgeInsets.only(top: 0, bottom: 55, left: 30, right: 30),
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('名前を登録する'),
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
              ])),
            )));
  }
}
