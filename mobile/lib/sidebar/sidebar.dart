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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.lightGreen.shade800,
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
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Atsushi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
                NewRow(
                  text: 'Test',
                  icon: Icons.bookmark,
                  sizeFont: 19,
                  onTap: () {},
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
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
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
