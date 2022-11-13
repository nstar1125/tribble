import 'package:flutter/material.dart';

// 가장 먼저 실행되는 페이지입니다
class SuperInitialPage extends StatelessWidget {
  const SuperInitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("guide\n가이드"),
              onPressed: () {
                Navigator.of(context).pushNamed('/toInitialPage');

              },
            ),
            SizedBox(width: 20,),
            ElevatedButton(
              child: Text("traveler\n트래블러"),
              onPressed: () {
                Navigator.of(context).pushNamed('/toInitialPageT');

              },
            ),
          ],
        ),
      ),
    );
  }
}
