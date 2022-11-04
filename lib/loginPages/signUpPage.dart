import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String userName = '';
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
          title: Text("회원가입",
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
                            validator: ((value) {
                              if(value!.isEmpty || value.length<3){
                                return "3글자 이상 입력하세요";
                              }
                              return null;
                            }),
                            onSaved: ((value) {
                              userName = value!;
                            }),
                            onChanged: (value){
                              userName = value;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "닉네임",
                              labelStyle: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                              ),
                            )
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: ((value) {
                              userEmail = value!;
                            }),
                            onChanged: (value){
                              userEmail = value;
                            },
                            validator: ((value) {
                              if(value!.isEmpty || !value.contains('@')){
                                return "올바른 이메일 형식으로 입력하세요";
                              }
                              return null;
                            }),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "이메일",
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
                              if(value!.isEmpty || value.length<8){
                                return "패스워드는 8자 이상 입력해야 합니다";
                              }
                              return null;
                            }),
                            onSaved: ((value) {
                              userPassword = value!;
                            }),
                            onChanged: (value){
                              userPassword = value;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "패스워드",
                              labelStyle: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                              ),
                            )
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "패스워드 확인",
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
                            child: Text("회원가입",
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () async{
                              _tryValidation();

                              try{
                                final newUser = await _authentication.createUserWithEmailAndPassword(

                                    email: userEmail,
                                    password: userPassword);
                                if(newUser.user != null){
                                  Navigator.of(context).pushNamed("/toLoungePage");
                                }
                              }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                      Text("이미 있거나 잘못된 이메일과 패스워드 입니다",
                                      style: TextStyle(
                                        fontFamily: "GmarketSansTTF",
                                        fontSize: 14,
                                      ),
                                      ),
                                    backgroundColor: Colors.lightBlueAccent,
                                  )
                                );
                              }
                            }
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
