import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/guide/homePage.dart';

class Chatloungepage extends StatefulWidget {
  const Chatloungepage({Key? key}) : super(key: key);

  @override
  _Chatloungestate createState() => _Chatloungestate();
}

class _Chatloungestate extends State<Chatloungepage> {
  final _auth = FirebaseAuth.instance;
  User? loginUser;
  final isMe = true;
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
          title: Text('채팅방'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/toLoungePage');
                })
          ],
        ),
        //카카오톡 채팅방 초기화면(유저별로 대화방 있음)
        // body: Container(
        //   child: StreamBuilder(
        //     stream: FirebaseFirestore.instance
        //         .collection('users')
        //         .limit(20)
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData) {
        //         return Center(
        //           child: CircularProgressIndicator(
        //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //           ),
        //         );
        //       } else {
        //         return ListView.builder(
        //           padding: EdgeInsets.all(10.0),
        //           itemBuilder: (context, index) =>
        //               buildItem(context, snapshot.data.documents[index]),
        //           itemCount: snapshot.data.documents.length,
        //         );
        //       }
        //     },
        //   ),
        // ),
        body: Row(
          children: [
            Container(
              //말풍선 모서리 깍는 부분.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(20),
                    bottomLeft:
                        isMe ? Radius.circular(20) : Radius.circular(0)),
              ),
              width: 300,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/talk.png'),
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, '/toChatPage');
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
