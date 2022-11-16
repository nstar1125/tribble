import 'package:flutter/material.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlanConfirmPage extends StatefulWidget {
  const PlanConfirmPage({Key? key}) : super(key: key);

  @override
  State<PlanConfirmPage> createState() => _PlanConfirmPageState();
}

class _PlanConfirmPageState extends State<PlanConfirmPage> {
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;
  late GoogleMapController _controller;

  final List<Set<Marker>> markersList = [];

  String tourTitle = "";
  int peanut_count = 0;
  List<bool> pickList = [];
  List<bool> showList = [];
  int eventCount = 100;
  _PlanConfirmPageState(){
    for(int i =0 ; i<eventCount; i++){
      pickList.add(true);
      showList.add(false);
    }
  }
  void addMarker(coordinate) {
    setState(() {
      Set<Marker> markers = {};
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      markersList.add(markers);
    });
  }
  flagToPt(bool flag){
    if(flag){
      return 2;
    }else{
      return 1;
    }
  }
  getTrueCount(List<bool> arr){
    int count = 0;
    for(int i=0; i<eventCount; i++)
      arr[i] ? count ++ : null;
    return count;
  }

  getTotalPt(List<bool> pList){
    int sum = 0;
    for(int i=0; i<eventCount; i++)
      pList[i] ? sum+=2 : sum+=1;
    return sum;
  }


  @override
  Widget build(BuildContext context) {
    List<Event> events = ModalRoute.of(context)!.settings.arguments as List<Event>;
    List<String> eventIdList = [];
    for(int i = 0; i < events.length; i++){
      eventIdList.add(events[i].getEventId());
      addMarker(LatLng(events[i].getLat(), events[i].getLng()));
    }
    eventCount = events.length;




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap:() {
              setState(() {
                peanut_count++;
              });
            },
            child: Container(
                child: Row(
                  children: [
                    Image(image: AssetImage("assets/images/peanut.png"),width: 20,),
                    SizedBox(width: 3),
                    Text("${peanut_count}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily:"GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(width:20)
                  ],
                )
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                  width:3,
                  height: showList[eventCount-1] ?
                    100*eventCount.toDouble()+300*(getTrueCount(showList)-1) :
                    100*eventCount.toDouble()+300*getTrueCount(showList),
                  color: Colors.lightBlueAccent
              ),
            ),
            Column(
              children: [
                Container(
                    height: 100*(eventCount.toDouble()+1)+300*getTrueCount(showList),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: eventCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showList[index] ?
                                    showList[index] = false :
                                    showList[index] = true;
                                    print(showList);
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:10, right:10),
                                              child: Container(
                                                  color: Colors.white,
                                                  child: Icon(Icons.circle_outlined,
                                                    color: Colors.lightBlueAccent,)),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Text(events[index].getTitle(),
                                                  style: TextStyle(
                                                      fontFamily: "GmarketSansTTF",
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Text(events[index].getTime1()+" "+events[index].getTime2(),
                                                  style: TextStyle(
                                                    fontFamily: "GmarketSansTTF",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Switch(
                                                value: pickList[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    pickList[index] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 6),
                                                    Image(image: AssetImage("assets/images/peanut.png"),width: 12,),
                                                    SizedBox(width: 3),
                                                    Text(flagToPt(pickList[index]).toString(),
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontFamily:"GmarketSansTTF",
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    ),
                                                    SizedBox(width:20)
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                              showList[index] ?
                                  Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width-80,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          child: GoogleMap(
                                            initialCameraPosition: CameraPosition(
                                              target: LatLng(events[index].getLat(), events[index].getLng()),
                                              zoom: 15.0,
                                            ),
                                            markers: markersList[index],
                                            onMapCreated: (GoogleMapController controller) {
                                              setState(() {
                                                _controller = controller;
                                              });
                                            },
                                          ),
                                        ),

                                        SizedBox(height: 20),
                                        Text(events[index].getLocation()!,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("설명",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("주제",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("작성자 ㅇㅇㅇ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),

                                      ],
                                    ),


                                  ) :
                                  Container()



                            ],
                          );
                        }
                    )
                ),

                Padding(
                  padding: const EdgeInsets.only(left:20, right:20),
                  child: Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 239, 239, 239)
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.edit),
                              Text(" What is the name of this tour?",
                                style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                            ]),
                        )
                          ,
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            onChanged: (value){
                              tourTitle = value;},
                          decoration: const InputDecoration(
                            hintText: "Tour title",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),

                SizedBox(height:30),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    onPressed: (){
                      if (peanut_count >= getTotalPt(pickList)){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/toMyPlanPage');
                        Navigator.of(context).pushNamed('/toPlanCheckPage', arguments: events);

                        // fix 버튼 누르면, 파이어베이스에 플랜 다큐먼트 업로드
                        final plan = <String, dynamic>{
                          "travelerId": currentUser.currentUser!.uid,
                          "title" : tourTitle,
                          "date1" : events[0].getDate1(),
                          "eventList": eventIdList
                        };

                        db.collection("plans").add(plan);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Not enough peanuts!",
                            style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ));
                      }
                    },
                    icon: Image(image: AssetImage("assets/images/peanut.png"),width: 20,),
                    label: Text("(${getTotalPt(pickList)}) Confirm my plan",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ))
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
