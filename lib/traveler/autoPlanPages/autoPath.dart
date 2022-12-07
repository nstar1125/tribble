import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import 'package:tribble_guide/traveler/createPlanPages/langTranslate.dart';

class AutoPath{
  late List<Event> eventPool; //탐색할 이벤트의 집합
  late List<String> foodList;  //음식 취향 리스트
  late List<String> placeList; //장소 취향 리스트
  late List<String> prefList;  //선호 취향 리스트
  late Event startE;
  late String type;

  AutoPath(List<Event> eList, List<List<String>> bias, String t){  //생성자
    type = t;
    LangTranslate lt = new LangTranslate();
    foodList = [];
    placeList = [];
    prefList = [];
    eventPool = eList;
    if(bias[0].isNotEmpty){
      bias[0].forEach((element) {
        foodList.add(lt.toKor(element));
      });
    }
    if(bias[1].isNotEmpty){
      bias[1].forEach((element) {
        placeList.add(lt.toKor(element));
      });
    }
    if(bias[2].isNotEmpty){
      bias[2].forEach((element) {
        prefList.add(lt.toKor(element));
      });
    }
    startE = getFirstE();
       //like, food, place, pref
  }

  makePath(int count){  //start event를 기준으로 count만큼 일정이 포함된 event list를 리턴하는 함수
    List<Event> path = [startE];  //path에 시작 이벤트를 포함한다.
    print("********** add first **********");
    print(startE.getTitle());
    print("*******************************");
    print("");
    for(int i = 0; i<count-1; i++){ //카운트만큼 반복하여 다음 이벤트를 path에 추가한다.
      Event nextBE= getNextE(path[path.length-1], true);  //뒤 이벤트 확인
      if(path[path.length-1] != nextBE){
        print("********** add behind **********");
        print(nextBE.getTitle());
        print("*******************************");
        print("");
        path.add(nextBE);
      }else{
        Event nextFE= getNextE(path[0], false);  //앞 이벤트 확인
        if(path[0] != nextFE){
          print("********** add front **********");
          print(nextFE.getTitle());
          print("*******************************");
          print("");
          path.insert(0, nextFE);
        }else{
          break;
        }
      }
    }
    return path;
  }
  getFirstE(){
    double maxPt = 0;
    int maxIdx = 0;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      print("from : "+eventPool[i].getTitle());
      print("to : "+eventPool[i].getTitle());
      double tempPt = getLinkPt(eventPool[i], eventPool[i]);
      if (maxPt<tempPt){
        maxPt = tempPt;
        maxIdx = i;
      }
    }
    Event firstE = eventPool[maxIdx];
    print("--------------->");
    print(eventPool.length);
    eventPool.removeAt(maxIdx);
    print(eventPool.length);
    print(">---------------");
    print("");
    return firstE;
  }
  getNextE(Event curEvent, bool lookAfter){ //다음 이벤트를 리턴하는 함수. 각 이벤트로의 링크 중 가장 높은 점수를 가진 이벤트를 리턴한다.
    double maxPt = 0;
    int maxIdx = -1;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      bool avail = false;
      if(lookAfter){
        if(getHour(eventPool[i].getTime1())>getHour(curEvent.getTime2())){
          avail = true;
        }else if(getHour(eventPool[i].getTime1())==getHour(curEvent.getTime2())){
          if(getMinute(eventPool[i].getTime1())>getMinute(curEvent.getTime2())){
            avail = true;
          }else if(getMinute(eventPool[i].getTime1())==getMinute(curEvent.getTime2())){
            avail = true;
          }
        }
      }else{
        if(getHour(eventPool[i].getTime2())<getHour(curEvent.getTime1())){
          avail = true;
        }else if(getHour(eventPool[i].getTime2())==getHour(curEvent.getTime1())){
          if(getMinute(eventPool[i].getTime2())<getMinute(curEvent.getTime1())){
            avail = true;
          }else if(getMinute(eventPool[i].getTime2())==getMinute(curEvent.getTime1())){
            avail = true;
          }
        }
      }
      if (avail){
        double tempPt;
        if(eventPool[i]!=curEvent){
          print("from : "+curEvent.getTitle());
          print("to : "+eventPool[i].getTitle());
          tempPt = getLinkPt(curEvent, eventPool[i]); //Start event로부터 각 event까지 링크의 점수를 계산
        }else{
          tempPt = 0;
        }
        if (maxPt<tempPt){
          maxPt = tempPt;
          maxIdx = i;
        }
      }
    }
    Event nextE;
    if(maxIdx == -1){
      print("<<<no events>>>");
      print("");
      nextE = curEvent;
    }else{
      nextE = eventPool[maxIdx];
      print("--------------->");
      print(eventPool.length);
      eventPool.removeAt(maxIdx);
      print(eventPool.length);
      print(">---------------");
      print("");
    }
    return nextE;
  }
  getLinkPt(Event s_node, Event e_node){ // 두 이벤트간 링크 점수를 계산하는 함수
    double distance;
    double timeDiff;
    double liked = e_node.getLike();
    if (s_node != e_node){
      distance =
          Geolocator.distanceBetween(s_node.getLat(),s_node.getLng(),e_node.getLat(),e_node.getLng());  //s_node와 e_node간 거리 점수
      timeDiff =
          (getHour(e_node.getTime1())-getHour(s_node.getTime2())).abs()+((getMinute(e_node.getTime1())-getMinute(s_node.getTime2())).toDouble()).abs()/60;
    }else{
      distance = 0;
      timeDiff = 0;
    }
    var bias  = getDupList(e_node.getFoodChoices(), foodList).length
                    +getDupList(e_node.getPlaceChoices(), placeList).length
                      +getDupList(e_node.getPrefChoices(), prefList).length;
    double total = 0;
    switch(type){
      case "like":
        total = (1000-distance)/100 + liked*10 + bias.toDouble()*10 + (240/(timeDiff+1));
        break;
      case "food":
        bias += getDupList(e_node.getFoodChoices(), foodList).length*10;
        total = (1000-distance)/100 + liked + bias.toDouble()*10 + (240/(timeDiff+1));
        break;
      case "place":
        bias += getDupList(e_node.getPlaceChoices(), placeList).length*10;
        total = (1000-distance)/100 + liked + bias.toDouble()*10 + (240/(timeDiff+1));
        break;
      case "pref":
        bias += bias += getDupList(e_node.getPrefChoices(), prefList).length*10;
        total = (1000-distance)/100 + liked + bias.toDouble()*10 + (240/(timeDiff+1));
        break;
    }
    print("distance : "+((1000-distance)/100).toString());
    print("liked : "+(liked*10).toString());
    print("bias : "+(bias*10).toString());
    print("time : "+(240/(timeDiff+1)).toString());
    print("TOTAL : "+total.toString());
    print("");
    return total;
  }
  getDupList(List<String> aList, List<String> bList){
    List<String> newList = [];
    if(aList.isEmpty || bList.isEmpty){
      return [];
    }
    if(aList.length > bList.length){
      for(int i = 0; i<bList.length; i++){
        if(aList.contains(bList[i])){
          newList.add(bList[i]);
        }
      }
    }else{
      for(int i = 0; i<aList.length; i++){
        if(bList.contains(aList[i])){
          newList.add(aList[i]);
        }
      }
    }
    return newList;
  }
  getHour(String s){
    s = s.replaceAll(" ~", "");
    var arr = s.split(" : ");
    return int.parse(arr[0]);
  }
  getMinute(String s){
    s = s.replaceAll(" ~", "");
    var arr = s.split(" : ");
    return int.parse(arr[1]);
  }
}