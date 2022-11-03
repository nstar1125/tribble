import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black87
          ),
          title: Text("Sign in",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
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
                  padding: const EdgeInsets.only(left:20, right:20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget> [
                        SizedBox(height: 20),
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: ((value) {
                              if(value!.isEmpty || !value.contains('@')){
                                return "Enter a valid email address";
                              }
                              return null;
                            }),
                            onSaved: ((value) {
                              userEmail = value!;
                            }),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Email address",
                              labelStyle: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                              ),
                            )
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            obscureText: true,
                            validator: ((value) {
                              if(value!.isEmpty){
                                return "Type in password";
                              }
                              return null;
                            }),
                            onSaved: ((value) {
                              userPassword = value!;
                            }),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Password",
                              labelStyle: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                              ),
                            )
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                              minimumSize: const Size.fromHeight(40)
                          ),
                          child: Text("Sign in",
                            style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                            ),
                          ),
                          onPressed: (){
                            _tryValidation();
                            if(_formKey.currentState!.validate()){
                              //Navigator.of(context).pushNamed("/toHome_page");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
            ),
          ),
        )
    );
  }
}


