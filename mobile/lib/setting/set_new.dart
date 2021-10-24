import 'package:flutter/material.dart';

class SetNew extends StatefulWidget {
  @override
   SetNewState createState() => SetNewState();
}

class SetNewState extends State<SetNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          children: [
//ここに書いていく
             Container(
            margin: EdgeInsets.only(top: 80, bottom: 0, left: 20, right: 20),
            child:Text("Setting これはテストです　消してください"),
          )
          ],
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}