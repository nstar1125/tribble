import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:tribble_guide/createEventPages/event.dart';

const kGoogleApiKey = "AIzaSyDJtGaKCd-UALmx7Qnoxb6LwKmUXZpk-78";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

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

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  List<Event> events = [];

  // 마커 이미지
  List<String> images = ['assets/images/marker1.jpg','assets/images/marker2.jpg', 'assets/images/marker3.jpg'];

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void addMarker(coordinate) async {
    final Uint8List markIcons = await getImages(images[markerId-1], 100);
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
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },

          ),
          Column(
            children: [
              const SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Event Count: ${events.length}",
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    markers.isEmpty? const Center() : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text("Search Events!",
                            style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                            ),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: () {
                            // pop으로 전달한 arguments를 e가 받음
                            Navigator.of(context).pushNamed("/toEventSearchListPage", arguments: detail.result).then((e) {  //장소+키워드+시간
                              if (e != null) {
                                markers.removeWhere((marker) => marker.markerId.value == "0");

                                Event myEvent = e as Event;
                                print(myEvent);
                                events.add(myEvent);
                                addMarker(LatLng(myEvent.getLat(), myEvent.getLng()));
                                print(markers);
                                _controller.animateCamera(CameraUpdate.newLatLng(LatLng(myEvent.getLat(), myEvent.getLng())));
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(
                          child: const Text(
                            "Create Auto Plan",
                            style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/toShowNomiPage');  // 현재위치+지금까지이벤트
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 50,),

                  ],
                ),
              ),
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

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.removeWhere((marker) => marker.markerId.value == "0");

    markers.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
    ));
    
    setState(() {});

    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 19.0));
  }

}
