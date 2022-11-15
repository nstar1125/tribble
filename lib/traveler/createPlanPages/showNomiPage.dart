import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

//자동 추천된 경로 리스트를 보여주는 페이지입니다 = 후보라는 뜻의 nominate에서 따옴
// 1. 다른 사람들이 많이 선택하는 인기있는 경로
// 2. 내가 선호하는 키워드만 존재하는 경로
// 3. 참신한 경로
// 4. 과거에 내가 선택했던 경로
// 여러 경로를 후보로 주고 고를 수 있게 하기

class ShowNomiPage extends StatefulWidget {
  const ShowNomiPage({Key? key}) : super(key: key);

  @override
  State<ShowNomiPage> createState() => _ShowNomiPageState();
}

class _ShowNomiPageState extends State<ShowNomiPage> {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('events');
  Event selectedEvent = Event.fromJson(initEvent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("Recommended Tour List",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Text(""),
    );
  }
}
