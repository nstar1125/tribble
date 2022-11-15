import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

class PlanCompletionPage extends StatefulWidget {
  const PlanCompletionPage({Key? key}) : super(key: key);

  @override
  State<PlanCompletionPage> createState() => _PlanCompletionPageState();
}

class _PlanCompletionPageState extends State<PlanCompletionPage> {
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List<Event> events = ModalRoute.of(context)!.settings.arguments as List<Event>;
    List<String> eventIdList = [];
    for(int i = 0; i < events.length; i++){
      eventIdList.add(events[i].getEventId());
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("Plan Page",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) => Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                        "${index+1} " + events[index].getTitle(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        )
                    ),
                    subtitle: Text(
                        events[index].getLocation()!,
                        style: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12,
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            child: const Text(
              "Confirm(Fix) my plan!",
              style: TextStyle(
                fontFamily: "GmarketSansTTF",
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/toFixPlanPage', arguments: events);

              // fix 버튼 누르면, 파이어베이스에 플랜 다큐먼트 업로드
              final plan = <String, dynamic>{
                "guideId": currentUser.currentUser!.uid,
                "eventList": eventIdList
              };

              db.collection("plans").add(plan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
