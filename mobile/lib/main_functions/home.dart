import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                      Text(
                        'HOME',
                        style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      Container(),
                    ],
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
