import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';
import 'package:tribble_guide/traveler/createPlanPages/langTranslate.dart';
import 'package:collection/collection.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class GetAPIPage extends StatefulWidget {
  const GetAPIPage({Key? key}) : super(key: key);

  @override
  State<GetAPIPage> createState() => _GetAPIPageState();
}

class _GetAPIPageState extends State<GetAPIPage> {
  var url = "https://apis.data.go.kr/B551011/EngService/locationBasedList?serviceKey=XN%2FesQfM49MU%2BbA5FbqGMUOT1CZfBskUfNYPs5G5Tr789RNHU7fAnq5OlwSz5AMwKvs5llHw45EY4whO5Fzxrw%3D%3D&numOfRows=100&pageNo=1&MobileOS=ETC&MobileApp=AppTest&_type=json&listYN=Y&arrange=A&mapX=126.9241498&mapY=37.5558499&radius=1000";
  var states = ["available", "helper", "guide"];
  var dates = ["2022 - 12 - 24", "2022 - 12 - 25", "2022 - 12 - 26"];
  var times = ["10 : 0 ~", "14 : 0 ~", "18 : 0 ~", "20 : 0 ~"];
  var times2 = ["12 : 0", "16 : 0", "20 : 0", "22 : 0"];
  var guideIds = ["mElCaL3v9VdPjPzJhwzFyeVIQ002", "Una2GVicvvfrKpwNlj1chFWxw5p2"];
  var guideNames =  ["smkk", "ldhguide"];
  var tagLists = [["kpop"], [""]];
  List<String> myFoods = [];
  List<String> myPlaces = [];
  List<String> myprefs = [];

  LangTranslate lt = LangTranslate();

  fetchData() async {
    final db = FirebaseFirestore.instance;
    // url로 받아오고
    //final response = await http.get(Uri.parse(url));
    String json = await rootBundle.loadString('assets/hongdae.json');
    // 홍대 주변 1km의 데이터 리스트 (71개)
    List<dynamic> myJsonList = convert.jsonDecode(json);
    // 71번 돌면서 event 파이어베이스에 업로드

    for(int i = 0 ; i < myJsonList.length; i++) {
      int dateRand = rand(dates.length);
      int timeRand = rand(times.length);

      myFoods.clear();
      if (myJsonList[i]['foodchoice'] != "0"){
        List<String> splittedFood = myJsonList[i]['foodchoice'].split(" ");
        for(int j = 0; j < splittedFood.length; j++) {
          myFoods.add(lt.foodListk[(int.parse(splittedFood[j])) - 1]);
        }
      }

      myPlaces.clear();
      if (myJsonList[i]['placechoice'] != "0"){
        List<String> splittedPlace = myJsonList[i]['placechoice'].split(" ");
        for(int j = 0; j < splittedPlace.length; j++) {
          myPlaces.add(lt.placeListk[(int.parse(splittedPlace[j])) - 1]);
        }
      }

      myprefs.clear();
      if (myJsonList[i]['prefchoice'] != "0"){
        List<String> splittedPref = myJsonList[i]['prefchoice'].split(" ");
        for(int j = 0; j < splittedPref.length; j++) {
          myprefs.add(lt.prefListk[(int.parse(splittedPref[j])) - 1]);
        }
      }


      await db.collection('events').add({
        'guideId': guideIds[rand(guideIds.length)],
        'guideName': guideNames[rand(guideNames.length)],
        'title': myJsonList[i]['body__items__item__title'],
        'location': myJsonList[i]['body__items__item__addr1'],
        'lat': double.parse(myJsonList[i]['body__items__item__mapy']),
        'lng': double.parse(myJsonList[i]['body__items__item__mapx']),
        'date1': dates[dateRand],
        'time1': times[timeRand],
        'date2': dates[dateRand],
        'time2': times2[timeRand],
        'selFoodChoices': myFoods,
        'selPlaceChoices': myPlaces,
        'selPrefChoices': myprefs,
        'imageList': <Asset>[],
        'tagList': tagLists[rand(tagLists.length)],
        'state': states[rand(states.length)],
        'like': rand(6).toDouble(),
        'count': rand(6).toDouble(),
      }).then((documentSnapshot) async => await db.collection('events').doc(documentSnapshot.id).update({"eventId": documentSnapshot.id}));
    }
  }

  int rand(int num) {
    return Random().nextInt(num);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("get"),
          onPressed: () {
            fetchData();
          },
        ),
      ),
    );
  }
}
