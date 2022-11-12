import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

const kGoogleApiKey = "AIzaSyDJtGaKCd-UALmx7Qnoxb6LwKmUXZpk-78";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class EventLocationPage extends StatefulWidget {
  const EventLocationPage({Key? key}) : super(key: key);

  @override
  State<EventLocationPage> createState() => _EventLocationPageState();
}


class _EventLocationPageState extends State<EventLocationPage> {

  // related google map
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(37.5052, 126.9571), zoom: 14.0);
  final Set<Marker> _marker = {};
  late GoogleMapController _controller;

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

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
            markers: _marker,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _marker.isEmpty? const Center() : Center(
                child: ElevatedButton(
                  child: const Text("이 장소로 결정!"),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/toEventDetailPage", arguments: detail.result);
                  },
                ),
              ),
              const SizedBox(height: 100,),
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
      language: "kr",
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: '장소를 입력하세요',
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

    _marker.clear();
    _marker.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, lng), infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 19.0));

  }
}
