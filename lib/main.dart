import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tribble_guide/chatPages/chatloungePage.dart';
import 'package:tribble_guide/myEventPages/eventDetailCheckPage.dart';
import 'package:tribble_guide/createEventPages/eventDetailWritingPage.dart';
import 'package:tribble_guide/createEventPages/eventLocationPage.dart';
import 'package:tribble_guide/myEventPages/myEventPage.dart';
import 'package:tribble_guide/loginPages/initialPage.dart';
import 'package:tribble_guide/loginPages/signInPage.dart';
import 'package:tribble_guide/loginPages/signUpPage.dart';
import 'package:tribble_guide/loungePage.dart';
import 'package:tribble_guide/chatPages/chatPage.dart';

void main() async {
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
          '/': (context) => const InitialPage(),
          '/toSignInPage': (context) => const SignInPage(),
          '/toSignUpPage': (context) => const SignUpPage(),
          '/toLoungePage': (context) => const LoungePage(),
          '/toEventLocationPage': (context) => const EventLocationPage(),
          '/toEventDetailWritingPage': (context) =>
              const EventDetailWritingPage(),
          '/toChatloungPage': (context) => const Chatloungepage(),
          '/toChatPage': (context) => const Chatpage(),
          '/toMyEventPage': (context) => const MyEventPage(),
        });
  }
}
