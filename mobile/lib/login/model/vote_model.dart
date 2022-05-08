import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoteModel extends ChangeNotifier {
  String changes = '';
  final _firestore = FirebaseFirestore.instance;
  void change() async {
    _firestore.collection("mtg").doc(changes).update(
      {
        "finish_vote": "true",
      },
    );
    notifyListeners();
  }
  
}
