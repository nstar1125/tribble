import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/traveler/autoPlanPages/autoPath.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:tribble_guide/traveler/autoPlanPages/autoPlanPage.dart';

//자동 추천된 경로 리스트를 보여주는 페이지입니다 = 후보라는 뜻의 nominate에서 따옴
// 여러 경로를 후보로 주고 고를 수 있게 하기

class ShowNomiPage extends StatefulWidget {
  const ShowNomiPage({Key? key}) : super(key: key);

  @override
  State<ShowNomiPage> createState() => _ShowNomiPageState();
}

class _ShowNomiPageState extends State<ShowNomiPage> {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('events');
  Event selectedEvent = Event.fromJson(initEvent);
  List<Event> events = [];
  List<List<String>> bias = [];

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    TravPref travPref = ModalRoute.of(context)!.settings.arguments as TravPref;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("Recommendation",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("# Popular Tour in Now",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {

                //// event pool 생성 시작
                List<Event> eventPool = [];

                QuerySnapshot querySnapshot = await db.collection("events").orderBy("date1").get();
                List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                if(allData.isNotEmpty) {
                  for(int i = 0; i < allData.length; i++) {

                    double distanceInMeters = Geolocator.distanceBetween(travPref.locDetail.geometry!.location.lat, travPref.locDetail.geometry!.location.lng,
                        allData[i]["lat"], allData[i]["lng"]);

                    // distance test
                    print("distance test : ${distanceInMeters}");

                    if(distanceInMeters < 1000){
                      Event selectedEvent = Event.fromJson(initEvent);

                      selectedEvent.setGuideId(allData[i]['guideId']);
                      selectedEvent.setGuideName(allData[i]['guideName']);
                      selectedEvent.setTitle(allData[i]['title']);
                      selectedEvent.setLocation(allData[i]['location']);
                      selectedEvent.setLatlng(allData[i]['lat'],allData[i]['lng']);
                      selectedEvent.setSTime(allData[i]['date1'], allData[i]['time1']);
                      selectedEvent.setFTime(allData[i]['date2'], allData[i]['time2']);
                      selectedEvent.setFoodChoices(allData[i]['selFoodChoices'].cast<String>());
                      selectedEvent.setPlaceChoices(allData[i]['selPlaceChoices'].cast<String>());
                      selectedEvent.setPrefChoices(allData[i]['selPrefChoices'].cast<String>());
                      //selectedEvent.setImages();
                      selectedEvent.setTags(allData[i]['tagList'].cast<String>());
                      selectedEvent.setEventId(allData[i]['eventId']);
                      selectedEvent.setState(allData[i]['state']);
                      selectedEvent.setLike(allData[i]['like']);
                      selectedEvent.setCount(allData[i]['count']);
                      if(selectedEvent.getDate1()==travPref.date){
                        bool avail = false;
                        if(getHour(selectedEvent.getTime1())>getHour(travPref.time)){
                          avail = true;
                        }else if(getHour(selectedEvent.getTime1())==getHour(travPref.time)){
                          if(getMinute(selectedEvent.getTime1())>getMinute(travPref.time)) {
                            avail = true;
                          }else if(getMinute(selectedEvent.getTime1())==getMinute(travPref.time)){
                            avail = true;
                          }
                        }
                        if(avail){
                          eventPool.add(selectedEvent);
                        }
                      }
                    }
                  }
                }
                //// 1km 내의 event pool 생성 끝
                // event pool test

                if(eventPool.length>0){
                  AutoPath auto = new AutoPath(eventPool, travPref.bias);
                  events = auto.makePath(travPref.count);
                  await Navigator.of(context).pushNamed('/toShowPathPage', arguments: events);
                }else{
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                    content: Text(
                      "No events found!\nPlease choose other place or date.",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ));
                }

                events.clear();
              },
              child: Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                      "Most Liked / Viewed Tour Now ;)",
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                      )
                  ),
                  subtitle: Text(
                      "12 : 10 ~",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 12,
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("# How About Your Own Plan?",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                //AutoPath auto = new AutoPath(eventPool, bias);
                //events = auto.makePath(count);

                /*
                final eventInfo1 = await FirebaseFirestore.instance.collection('events').doc('hfW0ZCKZPstiHtuqIpje').get();
                Event eventObj = Event.fromJson(eventInfo1.data()!);
                events.add(eventObj);

                final eventInfo2 = await FirebaseFirestore.instance.collection('events').doc('3JvlNTsYRDu5diXNzBAj').get();
                eventObj = Event.fromJson(eventInfo2.data()!);
                events.add(eventObj);
                */
                await Navigator.of(context).pushNamed('/toPlanConfirmPage', arguments: events);
                events.clear();
              },
              child: Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                      "Food Tour :)",
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                      )
                  ),
                  subtitle: Text(
                      "12 : 10 ~",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 12,
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  getHour(String s){
    s = s.replaceAll(" ~", "");
    var arr = s.split(" : ");
    return int.parse(arr[0]);
  }
  getMinute(String s){
    s = s.replaceAll(" ~", "");
    var arr = s.split(" : ");
    return int.parse(arr[1]);
  }
}
