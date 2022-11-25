import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';
import 'package:tribble_guide/chatPages/widgets/widgets.dart';
import 'package:tribble_guide/chatPages/profile_page.dart';
import 'package:tribble_guide/shopPage/shopPage.dart';

class HomePageT extends StatefulWidget {
  HomePageT({super.key, required this.tempPeanut});

  late int tempPeanut;

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {
  String userName = "";
  String email = "";
  final currentUser = FirebaseAuth.instance;

  final PageController pageController = PageController(
    initialPage: 0,
  );

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserpeanutsKey().then((val) {
      setState(() async {
        final db = FirebaseFirestore.instance;
        DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("users").doc(currentUser.currentUser!.uid!).get();

        widget.tempPeanut = docIdSnapshot.data()!["peanuts"];
      });
    });
    // getting the list of snapshots in our stream
  }

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // my tour에서 나오면 자동 피넛 업데이트
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingUserData();
      });
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            actions: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ShopPage()))
                      .then((value) async {
                    gettingUserData();
                  });
                },
                child: Container(
                    child: Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/peanut.png"),
                      width: 20,
                    ),
                    SizedBox(width: 3),
                    Text("${widget.tempPeanut}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 20)
                  ],
                )),
              )
            ],
            backgroundColor: Colors.white,
          ),
          drawer: Drawer(
              child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {
                  nextScreen(
                      context,
                      ProfilePage(
                        userName: userName,
                        email: email,
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )),
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
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_welcome_t.png"),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_culture_t.png"),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/home_illust_friends_t.png"),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.grey),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Popular Events",
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
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
                          Text(
                            "Popular Places",
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
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
          ));
    });
  }
}
