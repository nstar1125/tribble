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
    "🍽 식사",
    "🍺 술",
    "☕️ 카페",
    "🏮 시장",
  ];
  List<String> placeList = [
    "⛰ 풍경",
    "🏯 전통 장소",
    "🛍 쇼핑",
    "🪂 액티비티",
    "🏟 스포츠",
    "🎨 예술",
    "🎯 유흥/오락",
    "🧖 휴양",
    "🚶 산책",
  ];
  List<String> prefList = [
    "🎎 현지에서만",
    "🔥 핫플레이스",
    "📷 사진 명소",
    "🤳 혼자서도",
    "🎈 젊음의",
    "😌 여유로운"
  ];


  final currentUser = FirebaseAuth.instance;
  String _title = '';   //이벤트 제목
  TextEditingController tagCtrl = TextEditingController();
  String _date1 = "날짜 선택";  //일정 날짜 시작 (2022 년 11 월 11 일) 이런형식
  String _time1 = "시간 선택";  //일정 시간 시작 (11 시 11 분) 이런형식
  String _date2 = "날짜 선택";  //일정 날짜 끝
  String _time2 = "시간 선택";  //일정 시간 끝
  List<String> _selFoodChoices = [];
  List<String> _selPlaceChoices = [];
  List<String> _selPrefChoices = [];
  List<Asset> _imageList = <Asset>[];  //업로드한 이미지 리스트
  List<String> _tagList = <String>[];  //주제 해쉬태그 리스트
  Event myEvent = Event.fromJson(initEvent);  //생성할 이벤트


  // collection, document reference
  final collectionRef = FirebaseFirestore.instance.collection('events');
  final eventDocumentRef = FirebaseFirestore.instance.collection('events').doc();
  final userRef = FirebaseFirestore.instance.collection('users');
  String nickname = "";

  //이벤트 작성자의 이름까지 업로드
  //가이드아이디는 있음
  //

  Future nickNameFunc() async {
    userRef.doc(currentUser.currentUser!.uid).get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nickname = data["fullName"];
        }
    );
  }


  _setEvent(PlaceDetails detailResult) {  //이벤트 생성, *위치정보 추가해야함=>추가했음
    myEvent.setGuideId(currentUser.currentUser!.uid);

    myEvent.setGuideName(nickname);
    myEvent.setTitle(_title);
    //위치정보시작
    myEvent.setLocation(detailResult.formattedAddress);
    myEvent.setLatlng(detailResult.geometry!.location.lat, detailResult.geometry!.location.lng);
    //위치정보끝
    myEvent.setSTime(_date1, _time1);
    myEvent.setFTime(_date2, _time2);
    myEvent.setFoodChoices(_selFoodChoices);
    myEvent.setPlaceChoices(_selPlaceChoices);
    myEvent.setPrefChoices(_selPrefChoices);
    myEvent.setImages(_imageList);
    myEvent.setTags(_tagList);

  }

  //collection reference의 add함수를 이용해서 파이어베이스에 이벤트를 업로드
  Future _uploadEvent() async {
    Map<String, dynamic> eventMap = myEvent.toMap(); //이벤트객체에 저장된 각종 변수들을 Map타입으로 변환, 변환하는 이유는 add함수가 Map타입만 알아먹어서...

    await collectionRef.add(eventMap).then((documentSnapshot) {
      myEvent.setEventId(documentSnapshot.id);
      collectionRef.doc(documentSnapshot.id).update({"eventId": documentSnapshot.id});
    }
    );
  }


  _buildChoiceList(int type) {   //타입 1: food, 2: place, 3: pref
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

  getImage() async {    //이미지 업로드하는 함수
    List<Asset> resultList = <Asset>[];
    resultList =
      await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    setState(() {
      _imageList = resultList;
    });
  }

  addTag(String tag){   //해쉬태그 추가함수
    _tagList.add(tag);
  }
  popTag(){   //해쉬태그 마지막 제거함수
    setState(() {
      _tagList.removeLast();
    });

  }

  showMsg(String msg){    //Validation안될 시 메시지 스낵바로 출력하는 함수
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
    // 고른 장소에 대한 정보들이 담겨 있음.
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
        title: Text("이벤트 작성",
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
              Row(                                                  //제목
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit),
                    Text(" 제목",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Padding(                                                  //제목 텍스트 필드
                padding: const EdgeInsets.only(left:20, right:20),
                child: TextField(
                  onChanged: (value){
                    _title = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "이벤트 제목을 영어로 입력하세요!",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height:30),
              Row(                                                  //위치
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on),
                    Text(" 위치",
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Padding(                                                  //위치 정보
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
              Row(                                                  //일정시작
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time),
                    Text(" 일정 시작",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Row(                                                  //일정 시작 버튼 2개
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
              Row(                                                  //일정 끝
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time_filled),
                    Text(" 일정 끝",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              Row(                                                  //일정 끝 버튼 2개
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
              Row(                                                  //유형
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.textsms),
                    Text(" 유형",
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
                    Row(                                                  //유형
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.fastfood, color: Colors.grey,),
                          Text(" 식사",
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
                    Row(                                                  //유형
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.category, color: Colors.grey,),
                          Text(" 장소",
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
                    Row(                                                  //유형
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.emoji_emotions, color: Colors.grey,),
                          Text(" 성격",
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
              Row(                                                  //이미지
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera_alt),
                    Text(" 이미지",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
              _imageList.isEmpty                                   //이미지 리스트뷰
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
              Row(                                                  //이미지 선택
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
                      label: Text("이미지 선택",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 12,
                          ))
                  )
                ],
              ),
              Row(                                                  //주제
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.tag),
                    Text(" 주제",
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
              _tagList.isEmpty                                   //주제 리스트뷰
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
              Padding(                                             //주제 입력 텍스트필드
                padding: const EdgeInsets.only(left:20, right:20),
                child: TextField(
                  controller: tagCtrl,
                  decoration: const InputDecoration(
                    hintText: "주제 해쉬태그를 영어로 입력하세요!",
                  ),
                ),
              ),
              Padding(                                                  //제거, 선택 버튼
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
                        label: Text("제거",
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
                        label: Text("추가",
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
              ElevatedButton.icon(                      //업로드 버튼 -> 홈화면으로 복귀XXXXXX------> event의 상세 내용을 체크하는 페이지로 이동
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  onPressed: (){
                    if (_title == ''){                                  //validation
                      showMsg("제목을 입력하세요.");
                    }else if (_date1 == "날짜 선택" || _time1 == "시간 선택"){
                      showMsg("일정 시작을 선택해주세요.");
                    }else if (_date2 == "날짜 선택" || _time2 == "시간 선택"){
                      showMsg("일정 끝을 선택해주세요.");
                    }else if (_selFoodChoices.isEmpty || _selPlaceChoices.isEmpty || _selPrefChoices.isEmpty){
                      showMsg("유형을 선택해주세요.");
                    }else{
                      _setEvent(detailResult);  //입력받은 내용을 event 객체에 저장
                      _uploadEvent(); //파이어베이스에 event를 add
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/toMyEventPage');
                      Navigator.of(context).pushNamed('/toEventDetailCheckPage', arguments: myEvent); //작성한 event의 상세 내용을 체크하는 페이지로 라우팅
                    }
                  },
                  icon: Icon(Icons.upload,
                    size: 14,
                  ),
                  label: Text("이벤트 등록",
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
