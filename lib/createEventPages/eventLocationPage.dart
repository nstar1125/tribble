import 'package:flutter/material.dart';

class EventLocationPage extends StatefulWidget {
  const EventLocationPage({Key? key}) : super(key: key);

  @override
  State<EventLocationPage> createState() => _EventLocationPageState();
}

class _EventLocationPageState extends State<EventLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),
      body: Text("hi"),
    );
  }
}
