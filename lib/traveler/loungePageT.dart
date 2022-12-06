import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/traveler/homePageT.dart';

import '../chatPages/helper/helper_function.dart';

class LoungePageT extends StatefulWidget {
  const LoungePageT({Key? key}) : super(key: key);

  @override
  State<LoungePageT> createState() => _LoungePageTState();
}

class _LoungePageTState extends State<LoungePageT> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  int _selectedIndex = 0;
  int tempPeanut = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }



  List<Widget> _widgetOptionsFunc(tempPeanut) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePageT(tempPeanut: tempPeanut),
      HomePageT(tempPeanut: tempPeanut), //toEventLocationPage
      HomePageT(tempPeanut: tempPeanut),
      HomePageT(tempPeanut: tempPeanut),
    ];

    return _widgetOptions;
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? temp;
    if (loggedUser != null) {
      temp = loggedUser?.email;
    }
    return Scaffold(
      body: SafeArea(child: _widgetOptionsFunc(tempPeanut).elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: Colors.black87,
        selectedLabelStyle:
            TextStyle(fontFamily: "GmarketSansTTF", fontSize: 12),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle:
            TextStyle(fontFamily: "GmarketSansTTF", fontSize: 10),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.pushNamed(context, '/toPlanLocationPage').then((value) async {
                print("11*************");
                // read all documents from collection
                final db = FirebaseFirestore.instance;
                DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("users").doc(loggedUser!.uid).get();

                tempPeanut = docIdSnapshot.data()!["peanuts"];

                setState(() {

                });
              });
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/toMyPlanPage').then((value) async {
                // read all documents from collection
                final db = FirebaseFirestore.instance;
                DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("users").doc(loggedUser!.uid).get();

                tempPeanut = docIdSnapshot.data()!["peanuts"];

                setState(() {

                });
              });
            }
            if (index == 3) {
              Navigator.pushNamed(context, '/toChatloungPage');
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Plan tour"),
          BottomNavigationBarItem(icon: Icon(Icons.luggage), label: "My tour"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat")
        ],
      ),
    );
  }
}
