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
        color: Colors.white,
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
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
                          color: Colors.green,
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
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 60, bottom: 10, left: 30, right: 30),
                  child: Image(
                      image: AssetImage('lib/images/Logo_head.png'),
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate),
                  width: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 90, bottom: 0, left: 0, right: 10),
                          width: 125,
                          height: 125,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/create");
                            },
                            child: Text(
                              "ルームを作成\n     create",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 90, bottom: 0, left: 10, right: 10),
                          width: 125,
                          height: 125,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/join");
                            },
                            child: Text(
                              "ルームに参加\n        join",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 70, bottom: 0, left: 30, right: 30),
                  child: Image(
                      image: AssetImage('lib/images/Logo_name_2.png'),
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate),
                  width: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
