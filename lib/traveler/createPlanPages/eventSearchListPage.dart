import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tribble_guide/traveler/createPlanPages/planLocationPage.dart';

//지도에서 장소 하나를 검색하고 Search Event! 버튼을 누르면 나오는
//검색한 장소 근방 1km의 이벤트를 필터링해서 보여주는 페이지입니다
class EventSearchListPage extends StatefulWidget {
  const EventSearchListPage({Key? key}) : super(key: key);

  @override
  State<EventSearchListPage> createState() => _EventSearchListPageState();
}

class _EventSearchListPageState extends State<EventSearchListPage> {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('events');

  Event selectedEvent = Event.fromJson(initEvent);

  @override
  Widget build(BuildContext context) {
    //고른 장소의 위치를 얻기 위해 받아왔음
    LocaTimeTag ltt = ModalRoute.of(context)!.settings.arguments as LocaTimeTag;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text("Search Result",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: StreamBuilder(
        stream: collectionRef.snapshots(),
        builder: (context, snapshots) {
          if(snapshots.hasData) {
            return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = snapshots.data!.docs[index];

                //거리 1km 안의 이벤트만 리스트로 보여주기.. 앱 내 작동..
                double distanceInMeters = Geolocator.distanceBetween(ltt.locDetail.geometry!.location.lat, ltt.locDetail.geometry!.location.lng, documentSnapshot['lat'], documentSnapshot['lng']);


                //조건: 거리1km내 && (같은 날) && 같은 해시태그 가지는
                if(distanceInMeters < 1000 && (ltt.tag == "" || documentSnapshot['tagList'].contains(ltt.tag))) {
                  return GestureDetector(
                    onTap: () {
                      selectedEvent = Event.fromJson(documentSnapshot.data() as Map<String, dynamic>);
                      //클릭 시 해당 event의 상세 내용을 확인할 수 있는 페이지로 넘어감
                      //then은 두 번 pop하기 위한 장치
                      Navigator.of(context).pushNamed('/toEventDetailCheckPageT', arguments: selectedEvent).then((e) {
                        if(e != null){
                          Navigator.pop(context, e);
                        }
                      });
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
                            documentSnapshot['date1'] + ", " + documentSnapshot['location'],
                            style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12,
                            )
                        ),
                      ),
                    ),
                  );
                }
                else return Container();
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
