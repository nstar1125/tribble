import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';
import 'package:tribble_guide/guide/loungePage.dart';

class SignInPageT extends StatefulWidget {
  const SignInPageT({Key? key}) : super(key: key);

  @override
  State<SignInPageT> createState() => _SignInPageTState();
}

class _SignInPageTState extends State<SignInPageT> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String userEmail = '';
  String userPassword = '';
  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(
            "Sign in",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (() {
            FocusScope.of(context).unfocus();
          }),
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Enter a valid email address";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "email",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Type in password";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userPassword = value!;
                        }),
                        onChanged: (value) {
                          userPassword = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "password",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size.fromHeight(40)),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () async {
                        _tryValidation();
                        try {
                          final newUser =
                              await _authentication.signInWithEmailAndPassword(
                                  email: userEmail, password: userPassword);
                          QuerySnapshot snapshot = await DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .gettingUserData(userEmail);
                          // saving the values to our shared preferences
                          await HelperFunctions.saveUserLoggedInStatus(true);
                          await HelperFunctions.saveUserEmailSF(userEmail);
                          await HelperFunctions.saveUserNameSF(
                              snapshot.docs[0]['fullName']);
                          if (newUser.user != null) {
                            if (snapshot.docs[0]['type'] == "traveler") {
                              Navigator.of(context).pushNamed("/toLoungePage");
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Wrong user type",
                                  style: TextStyle(
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  ),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                              ));
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Wrong email or password",
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
