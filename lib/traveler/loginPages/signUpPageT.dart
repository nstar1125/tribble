import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';

class SignUpPageT extends StatefulWidget {
  const SignUpPageT({Key? key}) : super(key: key);

  @override
  State<SignUpPageT> createState() => _SignUpPageTState();
}

class _SignUpPageTState extends State<SignUpPageT> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String userName = '';
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
            "Sign Up",
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
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 3) {
                            return "Enter at least 3 characters";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userName = value!;
                        }),
                        onChanged: (value) {
                          userName = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "User name",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Enter a valid email address";
                          }
                          return null;
                        }),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Email address",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 8) {
                            return "Password must be at least 8 characters long";
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
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Password confirmation",
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
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                                    email: userEmail, password: userPassword);
                            await DatabaseService(uid: newUser.user!.uid)
                                .savingUserData(
                                    userName, userEmail, "traveler");
                            await HelperFunctions.saveUserLoggedInStatus(true);
                            await HelperFunctions.saveUserEmailSF(userEmail);
                            await HelperFunctions.saveUserNameSF(userName);
                            await HelperFunctions.saveUserIDSF(
                                newUser.user!.uid);

                            if (newUser.user != null) {
                              Navigator.of(context).pushNamed("/toLoungePageT");
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Wrong email or password is already exist",
                                style: TextStyle(
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                            ));
                          }
                        })
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
