import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tribble_guide/chatPages/chatPage.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';
import 'package:tribble_guide/traveler/createPlanPages/langTranslate.dart';

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
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String useremail = "";
  String groupid = "error";
  List<bool> showList = [];
  List<Event> events = [];
  int eventCount = 100;
  DocumentReference? groupDocumentReference;
  LangTranslate lt = new LangTranslate();
  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  _PlanCheckPageState() {
    for (int i = 0; i < eventCount; i++) {
      showList.add(false);
    }
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserusergroupSF().then((value) {
      setState(() {
        groupid = value!;
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
      markers = {};
    });
  }

  getTrueCount(List<bool> arr) {
    int count = 0;
    for (int i = 0; i < eventCount; i++) arr[i] ? count++ : null;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    events = ModalRoute.of(context)!.settings.arguments as List<Event>;
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
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/toLoungePageT'));
              },
              icon: Icon(Icons.logout)),
        ],
        automaticallyImplyLeading: false,
      ),
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
                      ? 80 * eventCount.toDouble() +
                          320 * (getTrueCount(showList) - 1)
                      : 80 * eventCount.toDouble() +
                          320 * getTrueCount(showList),
                  color: Colors.lightBlueAccent),
            ),
            Column(
              children: [
                Container(
                    height: 80 * (eventCount.toDouble() + 1) +
                        600 * getTrueCount(showList),
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
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
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
                                            onPressed: () async {
                                              final String?
                                                  abc =
                                                  await DatabaseService(
                                                          uid:
                                                              FirebaseAuth.instance
                                                                  .currentUser!.uid)
                                                      .createGroup(
                                                          userName,
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          events[index]
                                                              .getGuideName(),
                                                          events[index]
                                                              .getGuideId(),
                                                          events[index]
                                                              .getTitle());

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                              groupId: abc!,
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
                                      height: 320,
                                      color: Color.fromARGB(255, 239, 239, 239),
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: ListView(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            height: 120,
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    events[index].getLat(),
                                                    events[index].getLng()),
                                                zoom: 15.0,
                                              ),
                                              zoomGesturesEnabled: false,
                                              zoomControlsEnabled: false,
                                              markers: markersList[index],
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                setState(() {
                                                  _controller = controller;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Text(
                                                  events[index].getLocation()!,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: "GmarketSansTTF",
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Text("Type:",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          "GmarketSansTTF",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                for (var i in events[index]
                                                    .getFoodChoices())
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(lt.toEng(i),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                "GmarketSansTTF",
                                                            fontSize: 10,
                                                          ))),
                                                for (var i in events[index]
                                                    .getPlaceChoices())
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(lt.toEng(i),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                "GmarketSansTTF",
                                                            fontSize: 10,
                                                          ))),
                                                for (var i in events[index]
                                                    .getPrefChoices())
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(lt.toEng(i),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                "GmarketSansTTF",
                                                            fontSize: 10,
                                                          ))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Text("Hashtags:",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          "GmarketSansTTF",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                for (var i
                                                    in events[index].getTags())
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text("# " + i,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                "GmarketSansTTF",
                                                            fontSize: 10,
                                                          ))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, bottom: 10),
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "Guide:  ",
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontFamily:
                                                              "GmarketSansTTF",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text: events[
                                                                      index]
                                                                  .getGuideName(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    "GmarketSansTTF",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12,
                                                              )),
                                                        ]),
                                                  )),
                                            ],
                                          ),
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
