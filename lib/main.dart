import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tribble_guide/createEventPages/eventLocationPage.dart';
import 'package:tribble_guide/loginPages/initialPage.dart';
import 'package:tribble_guide/loginPages/signInPage.dart';
import 'package:tribble_guide/loginPages/signUpPage.dart';
import 'package:tribble_guide/loungePage.dart';


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
          '/':(context) => const InitialPage(),
          '/toSignInPage':(context) => const SignInPage(),
          '/toSignUpPage':(context) => const SignUpPage(),
          '/toLoungePage':(context) => const LoungePage(),
          '/toEventLocationPage':(context) => const EventLocationPage(),
        }

    );
  }
}

