import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Event> selectedPlan = [];

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

                // documentSnapshot = plan 하나
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];


                return GestureDetector(
                  onTap: () async{
                    for (int i = 0; i < documentSnapshot['eventList'].length; i++){
                      // plan의 eventList를 돌겠다. 돌면서 plan 객체에 저장하겠어
                      // event id
                      String eventId = documentSnapshot['eventList'][i];

                      final eventData = await db.collection("events").doc(eventId).get();
                      Event tempEvent = Event.fromJson(initEvent);
                      tempEvent.setGuideId(eventData.data()!["guideId"]);
                      tempEvent.setGuideName(eventData.data()!["guideName"]);
                      tempEvent.setTitle(eventData.data()!["title"]);
                      tempEvent.setLocation(eventData.data()!["location"]);
                      tempEvent.setLatlng(eventData.data()!["lat"],eventData.data()!["lng"]);
                      tempEvent.setSTime(eventData.data()!["date1"],eventData.data()!["time1"]);
                      tempEvent.setFTime(eventData.data()!["date2"],eventData.data()!["time2"]);
                      tempEvent.setFoodChoices(eventData.data()!["selFoodChoices"].cast<String>());
                      tempEvent.setPlaceChoices(eventData.data()!["selPlaceChoices"].cast<String>());
                      tempEvent.setPrefChoices(eventData.data()!["selPrefChoices"].cast<String>());
                      //tempEvent.setImages();
                      tempEvent.setTags(eventData.data()!["tagList"].cast<String>());

                      selectedPlan.add(tempEvent);

                    }
                    Navigator.of(context).pushNamed('/toPlanCheckPage', arguments: selectedPlan);
                    selectedPlan = [];
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
                          documentSnapshot['date1'],
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
