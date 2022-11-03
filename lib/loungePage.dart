import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoungePage extends StatefulWidget {
  const LoungePage({Key? key}) : super(key: key);

  @override
  State<LoungePage> createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

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
    return Scaffold(
      appBar: null,
      body: null,
    );
  }
}
