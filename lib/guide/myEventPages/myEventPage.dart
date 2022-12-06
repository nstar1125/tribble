import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({Key? key}) : super(key: key);

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('events');
  final currentUser = FirebaseAuth.instance;
  Event selectedEvent = Event.fromJson(initEvent);
  Color helperColor = Color.fromARGB(255, 198, 224, 180);
  Color guideColor = Color.fromARGB(255, 190, 215, 238);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("나의 이벤트",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: collectionRef.where('guideId', isEqualTo: currentUser.currentUser!.uid).snapshots(),  //where함수 이용해서 파이어베이스의 document를 필터링 할 수 있음, 로그인한 아이디의 event만 볼 수 있도록 설정
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {

                    selectedEvent.setGuideId(documentSnapshot['guideId']);
                    selectedEvent.setTitle(documentSnapshot['title']);
                    selectedEvent.setLocation(documentSnapshot['location']);
                    selectedEvent.setLatlng(documentSnapshot['lat'],documentSnapshot['lng']);
                    selectedEvent.setSTime(documentSnapshot['date1'], documentSnapshot['time1']);
                    selectedEvent.setFTime(documentSnapshot['date2'], documentSnapshot['time2']);
                    selectedEvent.setFoodChoices(documentSnapshot['selFoodChoices'].cast<String>());
                    selectedEvent.setPlaceChoices(documentSnapshot['selPlaceChoices'].cast<String>());
                    selectedEvent.setPrefChoices(documentSnapshot['selPrefChoices'].cast<String>());
                    //selectedEvent.setImages();
                    selectedEvent.setTags(documentSnapshot['tagList'].cast<String>());
                    selectedEvent.setGuideName(documentSnapshot['guideName']);
                    selectedEvent.setState(documentSnapshot['state']);

                    Navigator.of(context).pushNamed('/toEventDetailCheckPage', arguments: selectedEvent); // 클릭 시 해당 event의 상세 내용을 확인할 수 있는 페이지로 넘어감, WritingPage에서

                  },
                  child: Card(
                    color: (documentSnapshot['state']=="guide") ?
                      guideColor : (documentSnapshot['state']=="helper") ?
                        helperColor : Colors.white,
                    margin: EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['title'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        )
                      ),
                      subtitle: Text(
                        documentSnapshot['date1'] + ", " + documentSnapshot['location'],
                        style: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12,
                        )
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
