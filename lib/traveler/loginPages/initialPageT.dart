import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class InitialPageT extends StatelessWidget {
  const InitialPageT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Tribble",
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
                  child: Image(image: AssetImage("assets/images/lobby_illust_t.png")),
                )
                ,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child:
                  RichText(
                    text: TextSpan(
                        text: "Best way to make \n",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 20
                        ),
                        children: [
                          TextSpan(
                              text: "Local friends",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontWeight: FontWeight.bold,
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
                              const Text("Sign in with Email",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  )
                              ),
                            ],
                          ),

                          onPressed: () {
                            Navigator.of(context).pushNamed("/toSignInPageT"); // for test
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
                              const Text("Create account",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  )
                              ),
                            ],
                          ),

                          onPressed: () {
                            Navigator.of(context).pushNamed("/toSignUpPageT");
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
                          Navigator.pushNamed(context, '/toGetAPIPage');
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
