import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

class MyPlanPage extends StatefulWidget {
  const MyPlanPage({Key? key}) : super(key: key);

  @override
  State<MyPlanPage> createState() => _MyPlanPageState();
}

class _MyPlanPageState extends State<MyPlanPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('plans');
  final currentUser = FirebaseAuth.instance;
  Event tempEvent = Event.fromJson({  //이벤트 객체를 초기화하는 방법입니다~~ event.dart 파일의 fromJson메소드랑 같이 보시면 이해될듯!
    'guideId': "",
    'title': "",
    'location': "",
    'lat': 0.0,
    'lng': 0.0,
    'date1': "",
    'time1': "",
    'date2': "",
    'time2': "",
    'selectedChoices': <String>[],
    'imageList': <Asset>[],
    'tagList': <String>[],
    'eventId': "",
    'isBooked': false,
    'like': 0.0,
    'count': 0.0
  }
  );
  List<Event> selectedPlan = [];


  getStartDate(String eventId){
    final eventRef = db.collection("events").doc(eventId);
    String sDate = "";
    eventRef.get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              sDate = data["date1"];
            }
    );
    return sDate;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("My Plans",
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
        stream: collectionRef.where('travelerId', isEqualTo: currentUser.currentUser!.uid).snapshots(),  //where함수 이용해서 파이어베이스의 document를 필터링 할 수 있음, 로그인한 아이디의 event만 볼 수 있도록 설정
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                final eventRef = db.collection("events").doc(documentSnapshot['eventList'][0]);
                String sDate = "";
                eventRef.get().then(
                        (DocumentSnapshot doc) {
                      final data = doc.data() as Map<String, dynamic>;
                    }
                );


                return GestureDetector(
                  onTap: () {
                    for (int i = 0; i < documentSnapshot['eventList'].length; i++){
                      String eventId = documentSnapshot['eventList'][i];
                      final eventRef = db.collection("events").doc(eventId);
                      eventRef.get().then(
                          (DocumentSnapshot doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            tempEvent.setGuideId(data['guideId']);
                            tempEvent.setTitle(data['title']);
                            tempEvent.setLocation(data['location']);
                            tempEvent.setLatlng(data['lat'],data['lng']);
                            tempEvent.setSTime(data['date1'],data['time1']);
                            tempEvent.setFTime(data['date2'],data['time2']);
                            tempEvent.setChoices(data['selectedChoices'].cast<String>());
                            //tempEvent.setImages();
                            tempEvent.setTags(data['tagList'].cast<String>());
                            selectedPlan.add(tempEvent);
                            Navigator.of(context).pushNamed('/toPlanCheckPage', arguments: selectedPlan);
                            selectedPlan = [];
                          }
                      );
                    }


                    //초기화
                  },
                  child: Card(
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
                          //"${documentSnapshot['eventList'][index]}",
                          sDate,
                          //첫번째 이벤트의 시작 시간
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
