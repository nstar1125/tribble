import 'package:flutter/material.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tribble_guide/chatPages/chatPage.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';

class PlanCheckPage extends StatefulWidget {
  const PlanCheckPage({Key? key}) : super(key: key);

  @override
  State<PlanCheckPage> createState() => _PlanCheckPageState();
}

class _PlanCheckPageState extends State<PlanCheckPage> {
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  final List<Set<Marker>> markersList = [];
  String userName = "";
  String userId = "";
  String useremail = "";
  List<bool> showList = [];
  int eventCount = 100;
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  _PlanCheckPageState() {
    for (int i = 0; i < eventCount; i++) {
      showList.add(false);
    }
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserIDFromSF().then((value) {
      setState(() {
        userId = value!;
      });
    });
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        useremail = value!;
      });
    });
  }

  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      markersList.add(markers);
    });
  }

  getTrueCount(List<bool> arr) {
    int count = 0;
    for (int i = 0; i < eventCount; i++) arr[i] ? count++ : null;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events =
        ModalRoute.of(context)!.settings.arguments as List<Event>;
    List<String> eventIdList = [];
    for (int i = 0; i < events.length; i++) {
      eventIdList.add(events[i].getEventId());
      addMarker(LatLng(events[i].getLat(), events[i].getLng()));
    }
    eventCount = events.length;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "My Plan",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          leading: new IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                  width: 3,
                  height: showList[eventCount - 1]
                      ? 100 * eventCount.toDouble() +
                          300 * (getTrueCount(showList) - 1)
                      : 100 * eventCount.toDouble() +
                          300 * getTrueCount(showList),
                  color: Colors.lightBlueAccent),
            ),
            Column(
              children: [
                Container(
                    height: 100 * (eventCount.toDouble() + 1) +
                        300 * getTrueCount(showList),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: eventCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showList[index]
                                        ? showList[index] = false
                                        : showList[index] = true;
                                    print(showList);
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Container(
                                                  color: Colors.white,
                                                  child: Icon(
                                                    Icons.circle_outlined,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                  )),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Text(
                                                  events[index].getTitle(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "GmarketSansTTF",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  events[index].getTime1() +
                                                      " " +
                                                      events[index].getTime2(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "GmarketSansTTF",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: IconButton(
                                            onPressed: () {
                                              //1
                                              final snapshot = DatabaseService(
                                                      uid: events[index]
                                                          .getGuideId())
                                                  .getUserName();

                                              DatabaseService(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                  .createGroup(
                                                      // events[index]
                                                      //     .getGuideName(),
                                                      "last",
                                                      events[index]
                                                          .getGuideId(),
                                                      userName,
                                                      userId,
                                                      events[index].getTitle())
                                                  .whenComplete(() {});

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                              groupId: events[
                                                                      index]
                                                                  .getGuideId(),
                                                              groupName: events[
                                                                      index]
                                                                  .getTitle(),
                                                              userName:
                                                                  userName)));
                                            },
                                            icon: Icon(
                                              Icons.chat_bubble,
                                              color: Colors.lightBlueAccent,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              showList[index]
                                  ? Container(
                                      height: 300,
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    events[index].getLat(),
                                                    events[index].getLng()),
                                                zoom: 15.0,
                                              ),
                                              markers: markersList[index],
                                              onMapCreated: (GoogleMapController
                                                  controller) {
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
                                          Text("Guide: "+events[index].getGuideName(),
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: "GmarketSansTTF",
                                                fontSize: 14,
                                              )),
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          );
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
