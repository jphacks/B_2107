import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/setting/set_new.dart';

class Setting extends StatefulWidget {
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
   return Scaffold(
      body: Center(
          child: Container(
              child: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 90),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return CircleAvatar(
                      radius: 55.0,
                      backgroundImage:
                          NetworkImage(document.data()['user_image']),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                );
              }),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
        Container(
            margin: EdgeInsets.only(top: 15, bottom: 45, left: 90, right: 90),
            width: double.infinity,
            child: ElevatedButton(
                child: const Text('プロフィールを編集'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  primary: Colors.black87,
                  onPrimary: Colors.white,
                  elevation: 5,
                ),
                onPressed: () async {
                  final userRef = FirebaseFirestore.instance
                      .collection('user')
                      .where('uid', isEqualTo: uid);
                  userRef.get().then((snapshot) {
                    final List<String> documentID = [];
                    snapshot.docs.forEach((doc) {
                      documentID.add(doc.data()["documentID"]);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetProfile(documentID[0]),
                        ));
                  });
                })),
      ]))),
    );
  }
}
