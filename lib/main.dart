import 'package:flutter/material.dart';
import 'package:tribble_guide/loginPages/initialPage.dart';
import 'package:tribble_guide/loginPages/signInPage.dart';
import 'package:tribble_guide/loginPages/signUpPage.dart';

void main() {
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
        }

    );
  }
}

