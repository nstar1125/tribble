import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/traveler/homePageT.dart';

class LoungePageT extends StatefulWidget {
  const LoungePageT({Key? key}) : super(key: key);

  @override
  State<LoungePageT> createState() => _LoungePageTState();
}

class _LoungePageTState extends State<LoungePageT> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  final List<Widget> _widgetOptions = <Widget>[
    HomePageT(),
    HomePageT(),//toEventLocationPage
    HomePageT(),
    HomePageT(),
    HomePageT(),
  ];

  void getCurrentUser(){
    try{
      final user = _authentication.currentUser;
      if(user != null){
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? temp;
    if(loggedUser != null){
      temp = loggedUser?.email;
    }
    return Scaffold(
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      )
      ,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: Colors.black87,
        selectedLabelStyle: TextStyle(
            fontFamily: "GmarketSansTTF",
            fontSize: 12
        ),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
            fontFamily: "GmarketSansTTF",
            fontSize: 10
        ),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap:(int index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1){
              Navigator.pushNamed(context, '/toPlanLocationPage');
            }
          });
        },
        items: const[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: "Plan tour"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.luggage),
              label: "My tour"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Other tour"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: "Chat"
          )

        ],

      ),
    );
  }
}
