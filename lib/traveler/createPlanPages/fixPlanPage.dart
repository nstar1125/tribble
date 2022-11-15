import 'package:flutter/material.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';

class FixPlanPage extends StatefulWidget {
  const FixPlanPage({Key? key}) : super(key: key);

  @override
  State<FixPlanPage> createState() => _FixPlanPageState();
}

class _FixPlanPageState extends State<FixPlanPage> {
  @override
  Widget build(BuildContext context) {

    // 이 변수 사용하면 됩니다!~~ 이벤트들 들어있어요
    List<Event> events = ModalRoute.of(context)!.settings.arguments as List<Event>;

    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Text("hi"),
      ),
    );
  }
}
