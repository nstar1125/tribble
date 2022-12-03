import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:tribble_guide/traveler/createPlanPages/planLocationPage.dart';

const kGoogleApiKey = "AIzaSyDJtGaKCd-UALmx7Qnoxb6LwKmUXZpk-78";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

//Plan tour 버튼을 누르면 나오는 페이지입니다.
class ShowPathPage extends StatefulWidget {
  const ShowPathPage({Key? key}) : super(key: key);

  @override
  State<ShowPathPage> createState() => _ShowPathPageState();
}

class _ShowPathPageState extends State<ShowPathPage> {
  // related google map
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(37.5052, 126.9571), zoom: 14.0);
  Set<Marker> markers = {};
  static int markerId = 1;
  late GoogleMapController _controller;
  Set<Polyline> polyline = {};
  List<LatLng> points = [];
  List<Event> events = [];
  // 마커 이미지
  List<String> images = ['assets/images/marker1.png','assets/images/marker2.png',
    'assets/images/marker3.png', 'assets/images/marker4.png',
    'assets/images/marker5.png', 'assets/images/marker6.png'];

  final currentUser = FirebaseAuth.instance;
  bool firstBuild = true;

  void initState() {
    // TODO: implement initState
    super.initState();
    markerId = 1;
  }

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  addMarker(coordinate) async {
    final Uint8List markIcons = await getImages(images[markerId-1], 150);
    setState(() {
      markers.add(Marker(
          position: coordinate,
          markerId: MarkerId(markerId.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Remove ?"),
                    actions: [
                      TextButton(
                        child: Text("YES"),
                        onPressed: () async {
                          markers.clear();
                          points.remove(coordinate);
                          markers.removeWhere((marker) => marker.markerId.value == (points.indexOf(coordinate)+1).toString());
                          events.removeWhere((event) => LatLng(event.getLat(), event.getLng()) == coordinate);

                          markerId = 1;
                          for(int i = 0; i < points.length; i++){
                            await addMarker(points[i]);
                          }

                          setState(() {});

                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          }
      ));
    });
    markerId++;
  }
  buildPath() async{
    markers.removeWhere((marker) => marker.markerId.value == "0");
    for(int i = 0; i<events.length; i++){
      points.add(LatLng(events[i].getLat(), events[i].getLng()));
      polyline.add(Polyline(
        patterns: [
          PatternItem.dash(50),
          PatternItem.gap(50),
        ],
        polylineId: const PolylineId('0'),
        points: points,
        color: Colors.lightBlueAccent,
      ));

      //set state 포함
      await addMarker(LatLng(events[i].getLat(), events[i].getLng()));
    }
  }
  @override
  Widget build(BuildContext context) {
    events = ModalRoute.of(context)!.settings.arguments as List<Event>;
    if (firstBuild){
      buildPath();
      firstBuild = false;
    }
    return Scaffold(
      key: homeScaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black87
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            markerId = 1;
            Navigator.of(context).pop();
          },
        ),

      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: markers,
            polylines: polyline,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
              _controller.animateCamera(CameraUpdate.newLatLng(LatLng(events[-1].getLat(), events[-1].getLng())));
            },

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(events.length.toString()),
              Text(events[0].getTitle()),
              Text(events[1].getTitle()),
              Text(events[2].getTitle()),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                    elevation: 0,
                  ),
                  onPressed: () async{

                    final db = FirebaseFirestore.instance;
                    DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("users").doc(currentUser.currentUser!.uid!).get();

                    var eventsAndPeanutsObject = EventsAndPeanuts();
                    eventsAndPeanutsObject.events = events;
                    eventsAndPeanutsObject.peanuts = await docIdSnapshot.data()!["peanuts"];
                    if(!events.isEmpty){
                      Navigator.of(context).pushNamed('/toPlanConfirmPage', arguments: eventsAndPeanutsObject);
                    }

                  },
                  icon: Icon(Icons.arrow_forward,
                    color: Colors.black87,
                    size: 14,
                  ),
                  label: Text("Complete plan",
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 12,
                      ))
              ),
            ]
          )
        ],
      ),
    );
  }

}
