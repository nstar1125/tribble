import 'package:flutter/material.dart';

class EventDetailCheckPage extends StatefulWidget {
  const EventDetailCheckPage({Key? key}) : super(key: key);

  @override
  State<EventDetailCheckPage> createState() => _EventDetailCheckPageState();
}

// 이벤트 상세 내용 확인 페이지
class _EventDetailCheckPageState extends State<EventDetailCheckPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close)
        ),
        title: const Text("이벤트 상세 보기",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("go loungePage"),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName("/toLoungePage"));
          },
        ),
      ),
    );
  }
}
