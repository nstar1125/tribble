import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribble_guide/guide/myEventPages/eventDetailCheckPage.dart';

class EventDetailWritingPage extends StatefulWidget {
  const EventDetailWritingPage({Key? key}) : super(key: key);

  @override
  State<EventDetailWritingPage> createState() => _EventDetailWritingPageState();
}

class _EventDetailWritingPageState extends State<EventDetailWritingPage> {
  List<String> foodList = [
    "๐ฝ ์์ฌ",
    "๐บ ์ ",
    "โ๏ธ ์นดํ",
    "๐ฎ ์์ฅ",
  ];
  List<String> placeList = [
    "โฐ ํ๊ฒฝ",
    "๐ฏ ์ ํต ์ฅ์",
    "๐ ์ผํ",
    "๐ช ์กํฐ๋นํฐ",
    "๐ ์คํฌ์ธ ",
    "๐จ ์์ ",
    "๐ฏ ์ ํฅ/์ค๋ฝ",
    "๐ง ํด์",
    "๐ถ ์ฐ์ฑ",
  ];
  List<String> prefList = [
    "๐ ํ์ง์์๋ง",
    "๐ฅ ํซํ๋ ์ด์ค",
    "๐ท ์ฌ์ง ๋ช์",
    "๐คณ ํผ์์๋",
    "๐ ์ ์์",
    "๐ ์ฌ์ ๋ก์ด"
  ];


  final currentUser = FirebaseAuth.instance;
  String _title = '';   //์ด๋ฒคํธ ์ ๋ชฉ
  TextEditingController tagCtrl = TextEditingController();
  String _date1 = "๋ ์ง ์ ํ";  //์ผ์  ๋ ์ง ์์ (2022 ๋ 11 ์ 11 ์ผ) ์ด๋ฐํ์
  String _time1 = "์๊ฐ ์ ํ";  //์ผ์  ์๊ฐ ์์ (11 ์ 11 ๋ถ) ์ด๋ฐํ์
  String _date2 = "๋ ์ง ์ ํ";  //์ผ์  ๋ ์ง ๋
  String _time2 = "์๊ฐ ์ ํ";  //์ผ์  ์๊ฐ ๋
  List<String> _selFoodChoices = [];
  List<String> _selPlaceChoices = [];
  List<String> _selPrefChoices = [];
  List<Asset> _imageList = <Asset>[];  //์๋ก๋ํ ์ด๋ฏธ์ง ๋ฆฌ์คํธ
  List<String> _tagList = <String>[];  //์ฃผ์  ํด์ฌํ๊ทธ ๋ฆฌ์คํธ
  Event myEvent = Event.fromJson(initEvent);  //์์ฑํ  ์ด๋ฒคํธ


  // collection, document reference
  final collectionRef = FirebaseFirestore.instance.collection('events');
  final eventDocumentRef = FirebaseFirestore.instance.collection('events').doc();
  final userRef = FirebaseFirestore.instance.collection('users');
  String nickname = "";

  //์ด๋ฒคํธ ์์ฑ์์ ์ด๋ฆ๊น์ง ์๋ก๋
  //๊ฐ์ด๋์์ด๋๋ ์์
  //

  Future nickNameFunc() async {
    userRef.doc(currentUser.currentUser!.uid).get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nickname = data["fullName"];
        }
    );
  }


  _setEvent(PlaceDetails detailResult) {  //์ด๋ฒคํธ ์์ฑ, *์์น์ ๋ณด ์ถ๊ฐํด์ผํจ=>์ถ๊ฐํ์
    myEvent.setGuideId(currentUser.currentUser!.uid);

    myEvent.setGuideName(nickname);
    myEvent.setTitle(_title);
    //์์น์ ๋ณด์์
    myEvent.setLocation(detailResult.formattedAddress);
    myEvent.setLatlng(detailResult.geometry!.location.lat, detailResult.geometry!.location.lng);
    //์์น์ ๋ณด๋
    myEvent.setSTime(_date1, _time1);
    myEvent.setFTime(_date2, _time2);
    myEvent.setFoodChoices(_selFoodChoices);
    myEvent.setPlaceChoices(_selPlaceChoices);
    myEvent.setPrefChoices(_selPrefChoices);
    myEvent.setImages(_imageList);
    myEvent.setTags(_tagList);
    myEvent.setState("available");

  }

  //collection reference์ addํจ์๋ฅผ ์ด์ฉํด์ ํ์ด์ด๋ฒ ์ด์ค์ ์ด๋ฒคํธ๋ฅผ ์๋ก๋
  Future _uploadEvent() async {
    Map<String, dynamic> eventMap = myEvent.toMap(); //์ด๋ฒคํธ๊ฐ์ฒด์ ์ ์ฅ๋ ๊ฐ์ข ๋ณ์๋ค์ Mapํ์์ผ๋ก ๋ณํ, ๋ณํํ๋ ์ด์ ๋ addํจ์๊ฐ Mapํ์๋ง ์์๋จน์ด์...

    await collectionRef.add(eventMap).then((documentSnapshot) {
      myEvent.setEventId(documentSnapshot.id);
      collectionRef.doc(documentSnapshot.id).update({"eventId": documentSnapshot.id});
    }
    );
  }


  _buildChoiceList(int type) {   //ํ์ 1: food, 2: place, 3: pref
    List<Widget> choices = [];
    switch(type){
      case 1:
        foodList.forEach((item) {
          choices.add(Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              selectedColor: Colors.lightBlueAccent,
              label: Text(item),
              selected: _selFoodChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  _selFoodChoices.contains(item)
                      ? _selFoodChoices.remove(item)
                      : _selFoodChoices.add(item);
                });
              },
            ),
          ));
        });
        break;
      case 2:
        placeList.forEach((item) {
          choices.add(Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              selectedColor: Colors.lightBlueAccent,
              label: Text(item),
              selected: _selPlaceChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  _selPlaceChoices.contains(item)
                      ? _selPlaceChoices.remove(item)
                      : _selPlaceChoices.add(item);
                });
              },
            ),
          ));
        });
        break;
      case 3:
        prefList.forEach((item) {
          choices.add(Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              selectedColor: Colors.lightBlueAccent,
              label: Text(item),
              selected: _selPrefChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  _selPrefChoices.contains(item)
                      ? _selPrefChoices.remove(item)
                      : _selPrefChoices.add(item);
                });
              },
            ),
          ));
        });
        break;
    }
    return choices;
  }

  getImage() async {    //์ด๋ฏธ์ง ์๋ก๋ํ๋ ํจ์
    List<Asset> resultList = <Asset>[];
    resultList =
      await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    setState(() {
      _imageList = resultList;
    });
  }

  addTag(String tag){   //ํด์ฌํ๊ทธ ์ถ๊ฐํจ์
    _tagList.add(tag);
  }
  popTag(){   //ํด์ฌํ๊ทธ ๋ง์ง๋ง ์ ๊ฑฐํจ์
    setState(() {
      _tagList.removeLast();
    });

  }

  showMsg(String msg){    //Validation์๋  ์ ๋ฉ์์ง ์ค๋ต๋ฐ๋ก ์ถ๋ ฅํ๋ ํจ์
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(msg,
            style: TextStyle(
              fontFamily: "GmarketSansTTF",
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.lightBlueAccent,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // ๊ณ ๋ฅธ ์ฅ์์ ๋ํ ์ ๋ณด๋ค์ด ๋ด๊ฒจ ์์.
    nickNameFunc();
    PlaceDetails detailResult = ModalRoute.of(context)?.settings.arguments as PlaceDetails;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
            color: Colors.black87,
        ),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close)
        ),
        title: Text("์ด๋ฒคํธ ์์ฑ",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(                                                  //์ ๋ชฉ
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit),
                    Text(" ์ ๋ชฉ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Padding(                                                  //์ ๋ชฉ ํ์คํธ ํ๋
                padding: const EdgeInsets.only(left:20, right:20),
                child: TextField(
                  onChanged: (value){
                    _title = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "์ด๋ฒคํธ ์ ๋ชฉ์ ์์ด๋ก ์๋ ฅํ์ธ์!",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height:30),
              Row(                                                  //์์น
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on),
                    Text(" ์์น",
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Padding(                                                  //์์น ์ ๋ณด
                padding: const EdgeInsets.only(left:20, right:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:10),
                    Text(detailResult.name,
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                        )),
                    SizedBox(height:10),
                    Text(detailResult.formattedAddress!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
              SizedBox(height:30),
              Row(                                                  //์ผ์ ์์
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time),
                    Text(" ์ผ์  ์์",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Row(                                                  //์ผ์  ์์ ๋ฒํผ 2๊ฐ
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        backgroundColor: Colors.white
                      ),
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2023, 12, 31), onConfirm: (date) {
                              print('confirm $date');
                              _date1 = '${date.year} - ${date.month} - ${date.day}';
                              setState(() {});
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },

                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    " $_date1",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "GmarketSansTTF",
                                        fontSize: 16,
                                        ),
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),

                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        backgroundColor: Colors.white
                    ),
                    onPressed: (){
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            _time1 = '${time.hour} : ${time.minute} ~';
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              " $_time1",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),
              Row(                                                  //์ผ์  ๋
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time_filled),
                    Text(" ์ผ์  ๋",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Row(                                                  //์ผ์  ๋ ๋ฒํผ 2๊ฐ
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        backgroundColor: Colors.white
                    ),
                    onPressed: (){
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2023, 12, 31), onConfirm: (date) {
                            print('confirm $date');
                            _date2 = '${date.year} - ${date.month} - ${date.day}';
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  " $_date2",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),

                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        backgroundColor: Colors.white
                    ),
                    onPressed: (){
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            _time2 = '${time.hour} : ${time.minute}';
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              " $_time2",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),
              SizedBox(height:30),
              Row(                                                  //์ ํ
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.textsms),
                    Text(" ์ ํ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),

              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 239, 239, 239)),
                child: Column(
                  children: [
                    Row(                                                  //์ ํ
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.fastfood, color: Colors.grey,),
                          Text(" ์์ฌ",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              )
                          )
                        ]
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: _buildChoiceList(1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 239, 239, 239)),
                child: Column(
                  children: [
                    Row(                                                  //์ ํ
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.category, color: Colors.grey,),
                          Text(" ์ฅ์",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              )
                          )
                        ]
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: _buildChoiceList(2),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 239, 239, 239)),
                child: Column(
                  children: [
                    Row(                                                  //์ ํ
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.emoji_emotions, color: Colors.grey,),
                          Text(" ์ฑ๊ฒฉ",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              )
                          )
                        ]
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: _buildChoiceList(3),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height:30),
              Row(                                                  //์ด๋ฏธ์ง
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera_alt),
                    Text(" ์ด๋ฏธ์ง",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              _imageList.isEmpty                                   //์ด๋ฏธ์ง ๋ฆฌ์คํธ๋ทฐ
                  ? Container()
                  : Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Asset asset = _imageList[index];
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: AssetThumb(
                            asset: asset, width: 300, height: 300),
                        );
                      }),
                  ),
              Row(                                                  //์ด๋ฏธ์ง ์ ํ
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color.fromARGB(255, 220, 220, 220),
                        elevation: 0,
                      ),
                      onPressed: getImage,
                      icon: Icon(Icons.add,
                        color: Colors.black87,
                        size: 14,
                      ),
                      label: Text("์ด๋ฏธ์ง ์ ํ",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12,
                          ))
                  )
                ],
              ),
              Row(                                                  //์ฃผ์ 
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.tag),
                    Text(" ์ฃผ์ ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              SizedBox(height:10),
              _tagList.isEmpty                                   //์ฃผ์  ๋ฆฌ์คํธ๋ทฐ
                  ? Container()
                  : Container(
                height: _tagList.length*30,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: _tagList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "${_tagList[index]}",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 16,
                              )
                          ),
                        ),
                      );
                    }),
              ),
              Padding(                                             //์ฃผ์  ์๋ ฅ ํ์คํธํ๋
                padding: const EdgeInsets.only(left:20, right:20),
                child: TextField(
                  controller: tagCtrl,
                  decoration: const InputDecoration(
                    hintText: "์ฃผ์  ํด์ฌํ๊ทธ๋ฅผ ์์ด๋ก ์๋ ฅํ์ธ์!",
                  ),
                ),
              ),
              Padding(                                                  //์ ๊ฑฐ, ์ ํ ๋ฒํผ
                padding: const EdgeInsets.only(left:20, right:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Color.fromARGB(255, 220, 220, 220),
                          elevation: 0,
                        ),
                        onPressed: (){
                          if (_tagList.isNotEmpty){
                            popTag();
                          }
                        },
                        icon: Icon(Icons.remove,
                          color: Colors.black87,
                          size: 14,
                        ),
                        label: Text("์ ๊ฑฐ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12,
                            ))
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Color.fromARGB(255, 220, 220, 220),
                          elevation: 0,
                        ),
                        onPressed: (){
                          setState(() {
                            addTag(tagCtrl.text);
                            tagCtrl.clear();
                          });

                        },
                        icon: Icon(Icons.add,
                          color: Colors.black87,
                          size: 14,
                        ),
                        label: Text("์ถ๊ฐ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12,
                            ))
                    )
                  ],
                ),
              ),

              SizedBox(height: 50),
              ElevatedButton.icon(                      //์๋ก๋ ๋ฒํผ -> ํํ๋ฉด์ผ๋ก ๋ณต๊ทXXXXXX------> event์ ์์ธ ๋ด์ฉ์ ์ฒดํฌํ๋ ํ์ด์ง๋ก ์ด๋
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  onPressed: (){
                    if (_title == ''){                                  //validation
                      showMsg("์ ๋ชฉ์ ์๋ ฅํ์ธ์.");
                    }else if (_date1 == "๋ ์ง ์ ํ" || _time1 == "์๊ฐ ์ ํ"){
                      showMsg("์ผ์  ์์์ ์ ํํด์ฃผ์ธ์.");
                    }else if (_date2 == "๋ ์ง ์ ํ" || _time2 == "์๊ฐ ์ ํ"){
                      showMsg("์ผ์  ๋์ ์ ํํด์ฃผ์ธ์.");
                    }else if (_selFoodChoices.isEmpty && _selPlaceChoices.isEmpty && _selPrefChoices.isEmpty){
                      showMsg("์ ํ์ ์ ํํด์ฃผ์ธ์.");
                    }else{
                      _setEvent(detailResult);  //์๋ ฅ๋ฐ์ ๋ด์ฉ์ event ๊ฐ์ฒด์ ์ ์ฅ
                      _uploadEvent(); //ํ์ด์ด๋ฒ ์ด์ค์ event๋ฅผ add
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/toMyEventPage');
                      Navigator.of(context).pushNamed('/toEventDetailCheckPage', arguments: myEvent); //์์ฑํ event์ ์์ธ ๋ด์ฉ์ ์ฒดํฌํ๋ ํ์ด์ง๋ก ๋ผ์ฐํ
                    }
                  },
                  icon: Icon(Icons.upload,
                    size: 14,
                  ),
                  label: Text("์ด๋ฒคํธ ๋ฑ๋ก",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ))
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
