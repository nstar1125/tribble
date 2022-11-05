import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("트리블",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontWeight: FontWeight.bold,
                fontSize: 26
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                  child: Image(image: AssetImage("assets/images/lobby_illust.png")),
                )
                ,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child:
                  RichText(
                    text: TextSpan(
                        text: "지금 트리블과 함께 \n",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 20
                        ),
                        children: [
                          TextSpan(
                              text: "외국어 회화",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          TextSpan(
                              text: "를 연습하세요!",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 20
                              )
                          ),
                        ]
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                ,
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60, bottom: 30),
                  child: Column(
                    children: [

                      ButtonTheme(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("이메일로 로그인",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  )
                              ),
                            ],
                          ),

                          onPressed: () {
                            Navigator.of(context).pushNamed("/toSignInPage");
                          },

                        ),
                      ),
                      ButtonTheme(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.white70,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("회원가입",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  )
                              ),
                            ],
                          ),

                          onPressed: () {
                            Navigator.of(context).pushNamed("/toSignUpPage");
                          },

                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 110,
                          height: 1,
                          color: Colors.grey
                      ),
                      Text(" or ",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12
                          )
                      ),
                      Container(
                          width: 110,
                          height: 1,
                          color: Colors.grey
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 239, 239, 239)
                      ),
                      child: IconButton(
                        icon: Image.asset("assets/images/g_logo.png"),
                        onPressed:() {

                        },
                      ),
                    ),
                    SizedBox(width:30),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 7, 190, 52)
                      ),
                      child: IconButton(
                        icon: Image.asset("assets/images/p_logo.png"),
                        onPressed:() {

                        },
                      ),
                    ),
                    SizedBox(width:30),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 255, 228, 0)
                      ),
                      child: IconButton(
                        icon: Image.asset("assets/images/k_logo.png"),
                        onPressed:() {

                        },
                      ),
                    ),
                  ],)

              ],
            )
        )
    );
  }
}
