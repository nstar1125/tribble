import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tribble_guide/chatPages/chatloungePage.dart';
import 'package:tribble_guide/guide/myEventPages/eventDetailCheckPage.dart';
import 'package:tribble_guide/guide/createEventPages/eventDetailWritingPage.dart';
import 'package:tribble_guide/guide/createEventPages/eventLocationPage.dart';
import 'package:tribble_guide/guide/myEventPages/myEventPage.dart';
import 'package:tribble_guide/guide/loginPages/initialPage.dart';
import 'package:tribble_guide/guide/loginPages/signInPage.dart';
import 'package:tribble_guide/guide/loginPages/signUpPage.dart';
import 'package:tribble_guide/guide/loungePage.dart';
import 'package:tribble_guide/shopPage/shopPage.dart';
import 'package:tribble_guide/traveler/autoPlanPages/autoPlanPage.dart';
import 'package:tribble_guide/traveler/autoPlanPages/showPathPage.dart';

import 'package:tribble_guide/traveler/createPlanPages/eventDetailCheckPageT.dart';
import 'package:tribble_guide/traveler/createPlanPages/eventSearchListPage.dart';
import 'package:tribble_guide/traveler/homePageT.dart';
import 'package:tribble_guide/traveler/myPlanPages/getAPIPage.dart';
import 'package:tribble_guide/traveler/myPlanPages/planCheckPage.dart';

import 'package:tribble_guide/traveler/createPlanPages/planConfirm.dart';

import 'package:tribble_guide/traveler/createPlanPages/planLocationPage.dart';
import 'package:tribble_guide/superInitialPage.dart';
import 'package:tribble_guide/traveler/createPlanPages/showNomiPage.dart';
import 'package:tribble_guide/traveler/loginPages/initialPageT.dart';
import 'package:tribble_guide/traveler/loginPages/signInPageT.dart';
import 'package:tribble_guide/traveler/loginPages/signUpPageT.dart';
import 'package:tribble_guide/traveler/loungePageT.dart';

import 'package:tribble_guide/chatPages/chatPage.dart';
import 'package:tribble_guide/traveler/myPlanPages/myPlanPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
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
          '/': (context) => const SuperInitialPage(),

          //guide
          '/toInitialPage': (context) => const InitialPage(),
          '/toSignInPage': (context) => const SignInPage(),
          '/toSignUpPage': (context) => const SignUpPage(),
          '/toLoungePage': (context) => const LoungePage(),
          '/toEventLocationPage': (context) => const EventLocationPage(),
          '/toEventDetailWritingPage': (context) =>
              const EventDetailWritingPage(),
          '/toEventDetailCheckPage': (context) => const EventDetailCheckPage(),
          '/toMyEventPage': (context) => const MyEventPage(),
          '/toMyEventPage': (context) => const MyEventPage(),

          //traveler
          '/toInitialPageT': (context) => const InitialPageT(),
          '/toSignInPageT': (context) => const SignInPageT(),
          '/toSignUpPageT': (context) => const SignUpPageT(),
          '/toLoungePageT': (context) => const LoungePageT(),
          '/toPlanLocationPage': (context) => const PlanLocationPage(),
          '/toShowNomiPage': (context) => const ShowNomiPage(),

          '/toEventSearchListPage': (context) => const EventSearchListPage(),
          '/toEventDetailCheckPageT': (context) =>
              const EventDetailCheckPageT(),
          '/toPlanConfirmPage': (context) => const PlanConfirmPage(),
          '/toPlanCheckPage': (context) => const PlanCheckPage(),
          '/toMyPlanPage': (context) => const MyPlanPage(),
          '/toAutoPlanPage': (context) => const AutoPlanPage(),
          '/toShowPathPage': (context) => const ShowPathPage(),

          //common chat
          '/toChatloungPage': (context) => const Chatloungepage(),

          '/toShopPage': (context) => const ShopPage(),


          '/toGetAPIPage': (context) => const GetAPIPage(),

        });
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}