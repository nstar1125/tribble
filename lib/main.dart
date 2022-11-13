import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tribble_guide/myEventPages/eventDetailCheckPage.dart';
import 'package:tribble_guide/createEventPages/eventDetailWritingPage.dart';
import 'package:tribble_guide/createEventPages/eventLocationPage.dart';
import 'package:tribble_guide/myEventPages/myEventPage.dart';
import 'package:tribble_guide/loginPages/initialPage.dart';
import 'package:tribble_guide/loginPages/signInPage.dart';
import 'package:tribble_guide/loginPages/signUpPage.dart';
import 'package:tribble_guide/loungePage.dart';
import 'package:tribble_guide/traveler/createPlanPages/eventDetailCheckPageT.dart';
import 'package:tribble_guide/traveler/createPlanPages/eventSearchListPage.dart';
import 'package:tribble_guide/traveler/createPlanPages/planLocationPage.dart';
import 'package:tribble_guide/superInitialPage.dart';
import 'package:tribble_guide/traveler/createPlanPages/showNomiPage.dart';
import 'package:tribble_guide/traveler/loginPages/initialPageT.dart';
import 'package:tribble_guide/traveler/loginPages/signInPageT.dart';
import 'package:tribble_guide/traveler/loginPages/signUpPageT.dart';
import 'package:tribble_guide/traveler/loungePageT.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/':(context) => const SuperInitialPage(),

          //guide
          '/toInitialPage':(context) => const InitialPage(),
          '/toSignInPage':(context) => const SignInPage(),
          '/toSignUpPage':(context) => const SignUpPage(),
          '/toLoungePage':(context) => const LoungePage(),
          '/toEventLocationPage':(context) => const EventLocationPage(),
          '/toEventDetailWritingPage':(context) => const EventDetailWritingPage(),
          '/toEventDetailCheckPage':(context) => const EventDetailCheckPage(),
          '/toMyEventPage':(context) => const MyEventPage(),

          //traveler
          '/toInitialPageT':(context) => const InitialPageT(),
          '/toSignInPageT':(context) => const SignInPageT(),
          '/toSignUpPageT':(context) => const SignUpPageT(),
          '/toLoungePageT':(context) => const LoungePageT(),
          '/toPlanLocationPage':(context) => const PlanLocationPage(),
          '/toShowNomiPage':(context) => const ShowNomiPage(),
          '/toEventSearchListPage':(context) => const EventSearchListPage(),
          '/toEventDetailCheckPageT':(context) => const EventDetailCheckPageT(),
        }

    );
  }
}

