import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({Key? key}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    // 고른 장소에 대한 정보들이 담겨 있음.
    PlaceDetails detailResult = ModalRoute.of(context)?.settings.arguments as PlaceDetails;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.black87
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(detailResult.name),
            Text(detailResult.formattedAddress!),
          ],
        ),

      ),
    );
  }
}
