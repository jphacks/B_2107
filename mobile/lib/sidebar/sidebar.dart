import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/sidebar/new_row.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  final List<String> name = [];
  final List<String> image = [];

  // void getName()  {

  //   final userRef = FirebaseFirestore.instance
  //       .collection('user')
  //       .where('uid', isEqualTo: uid);
  //  userRef.get().then(
  //     (snapshot) {
  //       snapshot.docs.forEach((doc) {
  //         name.add(doc.data()["name"]);
  //       });
  //       snapshot.docs.forEach((doc) {
  //         image.add(doc.data()["user_image"]);
  //       });
  //     },
  //   );
  // }

  // void initState() {
  //   super.initState();
  //   getName();
  // }

  @override
  Widget build(BuildContext context) {
    @override
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .where('uid', isEqualTo: uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return Container(
                                child: Column(children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage:
                                    NetworkImage(document.data()['user_image']),
                                //backgroundColor: Colors.green,
                              ),
                              SizedBox(height: 10),
                              Text(
                                document.data()['name'],
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ]));
                          }).toList(),
                        );
                      }),
                ],
              ),
            ),
            Column(
              children: [
                NewRow(
                  text: 'Create',
                  icon: Icons.message,
                  sizeFont: 19,
                  onTap: () {
                    Navigator.of(context).pushNamed("/create");
                  },
                ),
                SizedBox(height: 20),
                NewRow(
                  text: 'Join',
                  icon: Icons.favorite,
                  sizeFont: 19,
                  onTap: () {
                    Navigator.of(context).pushNamed("/join");
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                auth.signOut();
                Navigator.of(context).pushNamed("/login");
              },
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.green[800].withOpacity(0.5),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
