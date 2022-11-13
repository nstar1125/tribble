import 'package:flutter/material.dart';

class HomePageT extends StatefulWidget {
  const HomePageT({Key? key}) : super(key: key);

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {

  int peanut_count = 0;

  final PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black87
          ),
          leading: new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {

            },
          ),
          actions: [
            GestureDetector(
              onTap:() {
                setState(() {
                  peanut_count++;
                });
              },
              child: Container(
                  child: Row(
                    children: [
                      Image(image: AssetImage("assets/images/peanut.png"),width: 20,),
                      SizedBox(width: 3),
                      Text("${peanut_count}",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily:"GmarketSansTTF",
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      SizedBox(width:20)
                    ],
                  )
              ),
            )


          ],
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 340,
                  child: PageView(
                    controller: pageController,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Image(image: AssetImage("assets/images/home_illust_welcome_g.png"),)
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Image(image: AssetImage("assets/images/home_illust_learn_g.png"),)
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Image(image: AssetImage("assets/images/home_illust_friends_g.png"),)
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(height:1, width: MediaQuery.of(context).size.width-40, color: Colors.grey),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Text("Popular Events",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily:"GmarketSansTTF",
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  height: 200,
                  child: PageView(
                    controller: pageController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.green),
                      )

                    ],
                  ),
                ),

                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Text("Popular Places",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily:"GmarketSansTTF",
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  height: 200,
                  child: PageView(
                    controller: pageController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.purple),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(color: Colors.green),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
