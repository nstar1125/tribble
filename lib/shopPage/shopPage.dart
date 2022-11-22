import 'package:flutter/material.dart';
import 'package:tribble_guide/shopPage/shopLang.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tribble_guide/chatPages/helper/helper_function.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _pExchange = 0;
  int _pCurrent = 0;
  ShopText st = new ShopText();

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  gettingUserData() async {
    await HelperFunctions.getUserpeanutsKey().then((val) {
      setState(() {
        _pCurrent = val!;
      });
    });
    // getting the list of snapshots in our stream
  }

  storeValues() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .updateuserpeanut(_pCurrent);
    await HelperFunctions.saveUserpeanutsKey(_pCurrent);
  }

  showPmsg(bool s) {
    if (s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          st.pMsgS,
          style: TextStyle(
            fontFamily: "GmarketSansTTF",
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          st.pMsgF,
          style: TextStyle(
            fontFamily: "GmarketSansTTF",
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEng = true;
    isEng ? st.setEng() : st.setKor();

    return WillPopScope(
        onWillPop: () async {
          storeValues();
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            title: Text(
              st.title,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "GmarketSansTTF",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image(
                  image: AssetImage("assets/images/peanut.png"),
                  width: 22,
                ),
                RichText(
                  text: TextSpan(
                      text: st.mainTxt,
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16),
                      children: [
                        TextSpan(
                            text: "${_pCurrent}",
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: "GmarketSansTTF",
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: st.suffixTxt,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16)),
                      ]),
                  textAlign: TextAlign.center,
                ),
              ]),
              Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 239, 239, 239)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(st.purchaseTxt,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Image(
                            image: AssetImage("assets/images/money.png"),
                            width: 18,
                          ),
                          Icon(Icons.arrow_right_alt),
                          Image(
                            image: AssetImage("assets/images/peanut.png"),
                            width: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/peanut.png"),
                                width: 18,
                              ),
                              Text(st.peanutTxt + " 10" + st.suffixTxt,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14)),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _pCurrent += 10;
                                  showPmsg(true);
                                });
                              },
                              child: Text("12,000" + st.currencyTxt,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 12)))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/peanut.png"),
                                width: 18,
                              ),
                              Text(st.peanutTxt + " 50" + st.suffixTxt,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14)),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _pCurrent += 50;
                                  showPmsg(true);
                                });
                              },
                              child: Text("60,000" + st.currencyTxt,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 12)))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/peanut.png"),
                                width: 18,
                              ),
                              Text(st.peanutTxt + " 100" + st.suffixTxt,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14)),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _pCurrent += 100;
                                  showPmsg(true);
                                });
                              },
                              child: Text("120,000" + st.currencyTxt,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 12)))
                        ],
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 239, 239, 239)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(st.exchangeTxt,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Image(
                            image: AssetImage("assets/images/peanut.png"),
                            width: 18,
                          ),
                          Icon(Icons.arrow_right_alt),
                          Image(
                            image: AssetImage("assets/images/money.png"),
                            width: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _pExchange = _pExchange - 10;
                                  if (_pExchange < 0) _pExchange = 0;
                                });
                              },
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.lightBlueAccent)),
                          Container(
                            color: Colors.white,
                            height: 20,
                            width: 200,
                            child: Center(
                              child: Text("${_pExchange}" + st.suffixTxt,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14)),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _pExchange = _pExchange + 10;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.lightBlueAccent,
                              ))
                        ],
                      ),
                      Icon(
                        Icons.arrow_downward,
                      ),
                      SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        height: 20,
                        width: 200,
                        child: Center(
                          child: Text("${_pExchange * 1000}" + st.currencyTxt,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14)),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: () {
                            if (_pExchange <= _pCurrent) {
                              setState(() {
                                _pCurrent -= _pExchange;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    st.eMsgS,
                                    style: TextStyle(
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                ));
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  st.eMsgF,
                                  style: TextStyle(
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 14,
                                  ),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                              ));
                            }
                          },
                          child: Text(st.eBtnTxt,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14)))
                    ],
                  ))
            ],
          ),
        ));
  }
}
