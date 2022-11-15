import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

const kGoogleApiKey = "AIzaSyDJtGaKCd-UALmx7Qnoxb6LwKmUXZpk-78";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class LocaTimeTag {
  late PlaceDetails locDetail;
  late String time;
  late String tag;
}

//Plan tour 버튼을 누르면 나오는 페이지입니다.
class PlanLocationPage extends StatefulWidget {
  const PlanLocationPage({Key? key}) : super(key: key);

  @override
  State<PlanLocationPage> createState() => _PlanLocationPageState();
}

class _PlanLocationPageState extends State<PlanLocationPage> {
  // related google map
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(37.5052, 126.9571), zoom: 14.0);
  final Set<Marker> markers = {};
  static int markerId = 1;
  late GoogleMapController _controller;
  final Set<Polyline> polyline = {};
  final List<LatLng> points = [];

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  List<Event> events = [];

  // 마커 이미지
  List<String> images = ['assets/images/marker1.png','assets/images/marker2.png',
    'assets/images/marker3.png', 'assets/images/marker4.png',
    'assets/images/marker5.png', 'assets/images/marker6.png'];

  //color
  Color recColor = Colors.grey;
  Color perColor = Colors.grey;
  Color completeColor = Colors.grey;

  //container change bool
  bool isClikedPersonally = false;
  bool hasSearched = false;

  String _date1 = "choose Day!";
  String _keyword = "";



  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void addMarker(coordinate) async {
    final Uint8List markIcons = await getImages(images[markerId-1], 150);
    setState(() {
      markers.add(Marker(
          position: coordinate,
          markerId: MarkerId(markerId.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
      ));
    });
    markerId++;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(onPressed: _handlePressButton, icon: const Icon(Icons.search))
        ],
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
            },

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: isClikedPersonally? Text(
                      "Event Count: ${events.length}",
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ) : Text("")
                  ),
                ],
              ),
              //isClikedPersonally
              !isClikedPersonally? Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(hasSearched){
                        Navigator.of(context).pushNamed('/toShowNomiPage');
                      }
                    },
                    child: Container(
                      color: recColor,
                      height: MediaQuery.of(context).size.height*(1/3),
                      width: MediaQuery.of(context).size.width/2,
                      child: Center(
                        child: Text(
                          "I want\nRecommended\nTour",
                          style: TextStyle(fontFamily: "GmarketSansTTF", fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(hasSearched) {
                        isClikedPersonally = true;
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: perColor,
                      height: MediaQuery.of(context).size.height*(1/3),
                      width: MediaQuery.of(context).size.width/2,
                      child: Center(
                        child: Text(
                          "I will\nMake My Tour\npersonally",
                          style: TextStyle(fontFamily: "GmarketSansTTF", fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                ],
                // 2번째 페이즈
              ) : Row(
                children: [
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height*(1/3),
                    width: MediaQuery.of(context).size.width*(3/5),
                    child: Column(
                      children: [
                        Row(                                                  //시간
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.access_time),
                              Text(" Time",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                            ]
                        ),
                        Row(                                                  //일정 시작 버튼 2개
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 0,
                                  backgroundColor: Colors.white
                              ),
                              onPressed: (){
                                DatePicker.showDatePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2023, 12, 31), onConfirm: (date) {
                                      print('confirm $date');
                                      _date1 = '${date.year} - ${date.month} - ${date.day}';
                                      setState(() {});
                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            " $_date1",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(                                                  //해시태그 검색
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(" # Keyword",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                            ]
                        ),
                        Padding(                                                  //해시태그 텍스트 필드
                          padding: const EdgeInsets.only(left:20, right:20),
                          child: TextField(
                            onChanged: (value){
                              _keyword = value;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your interested event keyword!",
                            ),
                          ),
                        ),

                        //검색 버튼
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: Colors.lightBlueAccent,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  // 최대 이벤트 수 6개
                                  if(events.length < 7){
                                    var locaTimeTagObject = LocaTimeTag();
                                    locaTimeTagObject.locDetail = detail.result;
                                    locaTimeTagObject.time = _date1;
                                    locaTimeTagObject.tag = _keyword;

                                    // pop으로 전달한 arguments를 e가 받음
                                    Navigator.of(context).pushNamed("/toEventSearchListPage", arguments: locaTimeTagObject).then((e) {  //장소+키워드+시간
                                      if (e != null) {
                                        markers.removeWhere((marker) => marker.markerId.value == "0");

                                        Event myEvent = e as Event;
                                        events.add(myEvent);

                                        points.add(LatLng(myEvent.getLat(), myEvent.getLng()));
                                        polyline.add(Polyline(
                                          patterns: [
                                            PatternItem.dash(50),
                                            PatternItem.gap(50),
                                          ],
                                          polylineId: const PolylineId('0'),
                                          points: points,
                                          color: Colors.lightBlueAccent,
                                        ));

                                        completeColor = Colors.lightBlueAccent;
                                        //set state 포함
                                        addMarker(LatLng(myEvent.getLat(), myEvent.getLng()));

                                        _controller.animateCamera(CameraUpdate.newLatLng(LatLng(myEvent.getLat(), myEvent.getLng())));


                                      }
                                    });
                                  }
                                },
                                icon: Icon(Icons.manage_search,
                                  color: Colors.black87,
                                  size: 14,
                                ),
                                label: Text("Search Event!",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 12,
                                    ))
                            ),
                          ),
                        )
                      ],

                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      if(!events.isEmpty){
                        Navigator.of(context).pushNamed('/toPlanCompletionPage', arguments: events);
                      }
                    },
                    child: Container(
                      color: completeColor,
                      height: MediaQuery.of(context).size.height*(1/3),
                      width: MediaQuery.of(context).size.width*(2/5),
                      child: Center(
                        child: Text(
                          "Complete\nMy Tour Plan!",
                          style: TextStyle(fontFamily: "GmarketSansTTF", fontSize: 37),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],

          )
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "eg",
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search Place',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "kr")],

    );

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {}

  // 검색 끝나면
  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.removeWhere((marker) => marker.markerId.value == "0");

    recColor = Colors.white;
    perColor = Colors.lightBlueAccent;

    // set State 포함
    markers.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
    ));

    hasSearched = true;

    setState(() {});

    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 19.0));
  }

}
