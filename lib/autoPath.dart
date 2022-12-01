import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class AutoPath{
  late List<Event> eventPool; //탐색할 이벤트의 집합
  late List<String> foodList;  //음식 취향 리스트
  late List<String> placeList; //장소 취향 리스트
  late List<String> prefList;  //선호 취향 리스트
  late Event startE;

  AutoPath(List<Event> eList, List<List<String>> bias){  //생성자
    eventPool = eList;
    foodList = bias[0];
    placeList = bias[1];
    prefList = bias[2];
    startE = getFirstE();
  }

  makePath(int count){  //start event를 기준으로 count만큼 일정이 포함된 event list를 리턴하는 함수
    List<Event> path = [startE];  //path에 시작 이벤트를 포함한다.
    for(int i = 1; i<count; i++){ //카운트만큼 반복하여 다음 이벤트를 path에 추가한다.
      path.add(getNextE(path[path.length-1]));
    }
    return path;
  }
  getFirstE(){
    int maxPt = 0;
    int maxIdx = 0;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      int tempPt = getLinkPt(eventPool[i], eventPool[i]);
      if (maxPt<tempPt){
        maxPt = tempPt;
        maxIdx = i;
      }
    }
    return eventPool[maxIdx];
  }
  getNextE(Event curEvent){ //다음 이벤트를 리턴하는 함수. 각 이벤트로의 링크 중 가장 높은 점수를 가진 이벤트를 리턴한다.
    int maxPt = 0;
    int maxIdx = 0;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      int tempPt = getLinkPt(curEvent, eventPool[i]); //Start event로부터 각 event까지 링크의 점수를 계산
      if (maxPt<tempPt){
        maxPt = tempPt;
        maxIdx = i;
      }
    }
    return eventPool[maxIdx];
  }
  getLinkPt(Event s_node, Event e_node){ // 두 이벤트간 링크 점수를 계산하는 함수
    double distance =
      Geolocator.distanceBetween(s_node.getLat(),s_node.getLng(),e_node.getLat(),e_node.getLng());  //s_node와 e_node간 거리 점수
    double liked = e_node.getLike();
    double bias  = getDupList(e_node.getFoodChoices(), foodList).length
                    +getDupList(e_node.getPlaceChoices(), placeList).length
                      +getDupList(e_node.getPrefChoices(), prefList).length;
    return distance + liked + bias;
  }
  getDupList(List<String> aList, List<String> bList){
    List<String> newList = [];
    if(aList.length > bList.length){
      for(int i = 0; i<aList.length; i++){
        if(aList.contains(bList[i])){
          newList.add(bList[i]);
        }
      }
    }else{
      for(int i = 0; i<bList.length; i++){
        if(bList.contains(aList[i])){
          newList.add(aList[i]);
        }
      }
    }
    return newList;
  }
}