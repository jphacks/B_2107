import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/setting/set_new.dart';

class Setting extends StatefulWidget {
  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  TextEditingController nameController = TextEditingController();
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User _user = FirebaseAuth.instance.currentUser;
    final String _uid = _user.uid.toString();
    Size size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.90 : 1.00)
        ..rotateZ(isDrawerOpen ? pi / 20 : 0),
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.lightGreen,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.menu,
                          size: 40,
                        ),
                        onTap: () {
                          if (isDrawerOpen) {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              isDrawerOpen = false;
                            });
                          } else {
                            setState(() {
                              xOffset = size.width - 120;
                              yOffset = size.height / 5;
                              isDrawerOpen = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 200),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SetNew()));
                    },
                    child: Text('編集'),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: _uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            return CircleAvatar(
                              radius: 55.0,
                              backgroundImage: NetworkImage(document.data()['user_image']),
                              backgroundColor: Colors.white,
                            );
                          }).toList(),
                        );
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: _uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            return Text((document.data()['name']),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ));
                          }).toList(),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
