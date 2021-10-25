import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetNew extends StatefulWidget {
  @override
  SetNewState createState() => SetNewState();
}

class SetNewState extends State<SetNew> {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 90.0,
              horizontal: 0,
            ),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: uid).snapshots(),
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
                      stream: FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            return TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: document.data()['name'],
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ));
                          }).toList(),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: OutlinedButton(
                    onPressed: () {
                      final userRef = FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: uid);
                      userRef.get().then((snapshot) {
                        final List<String> documentID = [];
                        snapshot.docs.forEach((doc) {
                          documentID.add(doc.data()["documentID"]);
                        });
                        FirebaseFirestore.instance.collection('user').doc(documentID[0]).update(
                          {
                            "name": _nameController.text,
                          },
                        );
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('変更を保存'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
