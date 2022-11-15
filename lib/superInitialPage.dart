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
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/toInitialPageT');
              },
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                child:  Image(image: AssetImage("assets/images/initial_traveler.png")),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/toInitialPage');
              },
              child: Container(
                color: Colors.lightBlueAccent,
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                child:  Image(image: AssetImage("assets/images/initial_guide.png")),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
