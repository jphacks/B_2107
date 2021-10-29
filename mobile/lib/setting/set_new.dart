import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

TextEditingController _nameController = TextEditingController();

class SetProfile extends StatefulWidget {
  @override
  SetProfileState createState() => SetProfileState();
  SetProfile(this.documentID);
  final documentID;
}

class SetProfileState extends State<SetProfile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user.uid.toString();

    // Future getImageFromGallery() async {
    //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

    //   setState(() {
    //     _image = File(pickedFile.path);
    //   });
    // }
    File file;
    final imagePicker = ImagePicker();
    void showBottomSheet() async {
      print(widget.documentID);
      final result = 1;
      if (result == 0) {
        final pickedFile =
            await imagePicker.getImage(source: ImageSource.camera);
        file = File(pickedFile.path);
      } else if (result == 1) {
        print(widget.documentID);
        final pickedFile =
            await imagePicker.getImage(source: ImageSource.gallery);
        file = File(pickedFile.path);
      } else {
        return;
      }
      try {
        var task = await firebase_storage.FirebaseStorage.instance
            .ref('user_icon/' + uid + '.jpg')
            .putFile(file);
        task.ref.getDownloadURL().then((downloadURL) => FirebaseFirestore
            .instance
            .collection("user")
            .doc(widget.documentID)
            .update({'user_image': downloadURL}));
      } catch (e) {
        print("Image upload failed");
        print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(widget.documentID)
                    .update(
                  {
                    "name": _nameController.text,
                  },
                );
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.black87,
              ),
              child: Text(
                '保存',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        body: Center(
            child: Container(
                child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 35),
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
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
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
            margin: EdgeInsets.only(top: 15),
            child: TextButton(
              onPressed: () {
                showBottomSheet();
              },
              child: Text(
                'プロフィール画像を変更する',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 0, left: 35, right: 35),
            child: TextFormField(
              controller: _nameController,
              onChanged: (String value) {},
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
        ]))));
  }
}
