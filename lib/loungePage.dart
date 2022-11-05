import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/homePage.dart';

class LoungePage extends StatefulWidget {
  const LoungePage({Key? key}) : super(key: key);

  @override
  State<LoungePage> createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage> {
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
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
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
              Navigator.pushNamed(context, '/toEventLocationPage');
            }
          });
        },
        items: const[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "홈"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_location_alt),
              label: "이벤트 작성"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "나의 이벤트"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: "트렌드 분석"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: "채팅"
          )

        ],

      ),
    );
  }
}
