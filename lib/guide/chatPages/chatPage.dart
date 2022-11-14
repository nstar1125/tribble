import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/guide/chatPages/message.dart';
import 'package:tribble_guide/guide/chatPages/new_message.dart';
import 'package:tribble_guide/guide/homePage.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({Key? key}) : super(key: key);

  @override
  _Chatpagestate createState() => _Chatpagestate();
}

class _Chatpagestate extends State<Chatpage> {
  final _auth = FirebaseAuth.instance;
  User? loginUser;

  @override
  void initState() {
    super.initState();
    //현재 유저를 받는 함수
    //getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loginUser = user;
        print(loginUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1:1 채팅방'), //추후 상대방이름으로 변경
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/toChatloungePage'); //1:1채팅방 나가기
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
