import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';
import 'package:tribble_guide/chatPages/widgets/widgets.dart';
import 'package:tribble_guide/chatPages/profile_page.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:tribble_guide/shopPage/shopPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageT extends StatefulWidget {
  HomePageT({super.key, required this.tempPeanut});

  late int tempPeanut;

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {
  String userName = "";
  String email = "";
  List<Event> stack = [];

  CollectionReference collectionRef = FirebaseFirestore.instance.collection('events');
  final db = FirebaseFirestore.instance;
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  final List<Set<Marker>> markersList = [];
  final currentUser = FirebaseAuth.instance;

  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: const MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      Set<Marker> temp = markers;
      markersList.add(temp);
      markers = {};
    });
  }

  final PageController pageController = PageController(
    initialPage: 0,
  );

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserpeanutsKey().then((val) async {

      DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("users").doc(currentUser.currentUser!.uid!).get();

      widget.tempPeanut = docIdSnapshot.data()!["peanuts"];

    });
    // getting the list of snapshots in our stream
  }
  getTopEvents() async{
    QuerySnapshot querySnapshot = await db.collection("events").orderBy("count").get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    if(allData.isNotEmpty && stack.length==0) {
      int i = 0;
      double max = 0;
      for(int i = 0; i < allData.length; i++) {
        double count = allData[i]['count'];
        if(count>=max){
          max = count;
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
          if(stack.length<3){
            stack.add(selectedEvent);
          }else{
            stack.add(selectedEvent);
            stack.removeAt(0);
          }
        }
      }
    }
  }
  bool firstBuild = true;
  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getTopEvents();
    if(stack.length>0){
      if(firstBuild){
        for (int i = 0; i < stack.length; i++) {
          addMarker(LatLng(stack[i].getLat(), stack[i].getLng()));
          firstBuild = false;
        }
      }
    }
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingUserData();
      });
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ShopPage()))
                      .then((value) async {
                    gettingUserData();
                  });
                },
                child: Container(
                    child: Row(
                  children: [
                    const Image(
                      image: AssetImage("assets/images/peanut.png"),
                      width: 20,
                    ),
                    const SizedBox(width: 3),
                    Text("${widget.tempPeanut}",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 20)
                  ],
                )),
              )
            ],
            backgroundColor: Colors.white,
          ),
          drawer: Drawer(
              child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {
                  nextScreen(
                      context,
                      ProfilePage(
                        userName: userName,
                        email: email,
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 340,
                    child: PageView(
                      controller: pageController,
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_welcome_t.png"),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_culture_t.png"),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_friends_t.png"),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.grey),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: const [
                          SizedBox(width: 20),
                          Text(
                            "Popular Events",
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Column(
                      children: List.generate(stack.length, (i){
                        return GestureDetector(
                          onTap: (){
                            var btnnEvent = BtnnEvent();
                            btnnEvent.event = stack[i];
                            btnnEvent.isBtn = false;
                            Navigator.of(context).pushNamed('/toEventDetailCheckPageT', arguments: btnnEvent); // 클릭 시 해당 event의 상세 내용을 확인할 수 있는 페이지로 넘어감, WritingPage에서
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left:20, right:20,bottom:20),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: const Color.fromARGB(155, 190, 215, 238),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    height: 120,
                                    child: Stack(
                                      children: [
                                        GoogleMap(
                                          zoomGesturesEnabled: false,
                                          zoomControlsEnabled: false,
                                          initialCameraPosition:
                                          CameraPosition(
                                            target: LatLng(
                                                stack[i].getLat(),
                                                stack[i].getLng()),
                                            zoom: 15.0,
                                          ),
                                          markers: markersList[i],
                                          onMapCreated: (GoogleMapController
                                          controller) {
                                            setState(() {
                                              _controller = controller;
                                            });
                                          },
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 120,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: Text(
                                            "#${i+1}. "+" "+stack[i].getTitle()!,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Text(
                                          stack[i].getLocation()!,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 12,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
class BtnnEvent{
  late Event event;
  late bool isBtn;
}