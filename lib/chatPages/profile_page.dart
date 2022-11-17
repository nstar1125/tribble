import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:tribble_guide/image/Add.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? userPickedImage;
  String userid = "";
  @override
  void initState() {
    gettingid();
    super.initState();
  }

  gettingid() {
    userid = FirebaseAuth.instance.currentUser!.uid;
  }

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(pickedImage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black87, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(widget.userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(widget.email, style: const TextStyle(fontSize: 17)),
              ],
            ),
            GestureDetector(
              onTap: () async {
                showAlert(context);

                final refImage = FirebaseStorage.instance
                    .ref()
                    .child('picked_image')
                    .child(userid + '.png');

                await refImage.putFile(userPickedImage!);
                final url = await refImage.getDownloadURL();

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userid)
                    .update({"url": url});
              },
              child: Icon(
                Icons.image,
                color: Colors.grey[300],
              ),
            )
          ],
        ),
      ),
    );
  }
}
