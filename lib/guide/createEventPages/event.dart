import 'package:multi_image_picker/multi_image_picker.dart';

Map<String, dynamic> initEvent = {
  'guideId': "",
  'guideName': "",
  'title': "",
  'location': "",
  'lat': 0.0,
  'lng': 0.0,
  'date1': "",
  'time1': "",
  'date2': "",
  'time2': "",
  'selFoodChoices': <String>[],
  'selPlaceChoices': <String>[],
  'selPrefChoices': <String>[],
  'imageList': <Asset>[],
  'tagList': <String>[],
  'eventId': "",
  'state': "",
  'like': 0.0,
  'count': 0.0
};

Map<String, dynamic> firstEvent = {
  'guideId': "Una2GVicvvfrKpwNlj1chFWxw5p2",
  'guideName': "smkk",
  'title': "Fish and sushi",
  'location': "6-12, Yanghwa-ro 7-gil, Mapo-gu, Seoul",
  'lat': 37.5516159646,
  'lng': 126.9156105083,
  'date1': "2022 - 12 - 26",
  'time1': "18 : 0 ~",
  'date2': "2022 - 12 - 26",
  'time2': "20 : 0",
  'selFoodChoices': ["🍽 식사"],
  'selPlaceChoices': <String>[],
  'selPrefChoices': <String>[],
  'imageList': <Asset>[],
  'tagList': <String>[],
  'eventId': "cuYe6Vd3wYKEq4QZpFw5",
  'state': "available",
  'like': 5.0,
  'count': 6.0
};

Map<String, dynamic> secondEvent = {
  'guideId': "Una2GVicvvfrKpwNlj1chFWxw5p2",
  'guideName': "smkk",
  'title': "Lunch for Dongasue",
  'location': "39-13, Wausanro-gil, Mapo-gu, Seoul",
  'lat': 37.5480526094,
  'lng': 126.9222655578,
  'date1': "2022 - 12 - 26",
  'time1': "14 : 0 ~",
  'date2': "2022 - 12 - 26",
  'time2': "16 : 0",
  'selFoodChoices': ["🍽 식사"],
  'selPlaceChoices': <String>[],
  'selPrefChoices': <String>[],
  'imageList': <Asset>[],
  'tagList': <String>[],
  'eventId': "9GgUPROgP3GfUPmHSdJi",
  'state': "available",
  'like': 5.0,
  'count': 6.0
};

class Event{
  String _guideId = "";
  String _guideName = "";
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _date1 = "";
  String _time1 = "";
  String _date2 = "";
  String _time2 = "";
  List<String> _selFoodChoices = <String>[];
  List<String> _selPlaceChoices = <String>[];
  List<String> _selPrefChoices = <String>[];
  List<Asset> _imageList = <Asset>[];
  List<String> _tagList = <String>[];
  String _eventId = "";
  String _state = "";
  double _like = 0.0;
  double _count = 0.0;
  // like, isBooked, count


  setGuideName(String name){
    _guideName = name;
  }
  setGuideId(String id){
    _guideId = id;
  }
  setTitle(String title){
    _title = title;
  }
  setLocation(String? location){
    _location = location;
  }
  setLatlng(double lat, double lng){
    _lat = lat;
    _lng = lng;
  }
  setSTime(String date, String time){
    _date1 = date;
    _time1 = time;
  }
  setFTime(String date, String time){
    _date2 = date;
    _time2 = time;
  }
  setFoodChoices(List<String> arr){
    _selFoodChoices = arr;
  }
  setPlaceChoices(List<String> arr){
    _selPlaceChoices = arr;
  }
  setPrefChoices(List<String> arr){
    _selPrefChoices = arr;
  }
  setImages(List<Asset> arr){
    _imageList = arr;
  }
  setTags(List<String> arr){
    _tagList = arr;
  }
  setEventId(String id){
    _eventId = id;
  }
  setState(String state){
    _state = state;
  }
  setLike(double like){
    _like = like;
  }
  setCount(double count){
    _count = count;
  }
  addLike(){
    _like = _like + 1;
  }
  subLike(){
    if(_like > 0){
      _like = _like - 1;
    }
  }
  addCount(){
    _count = _count + 1;
  }
  subCount(){
    if(_count > 0){
      _count = _count - 1;
    }
  }

  String getGuideName(){
    return _guideName;
  }
  String getGuideId(){
    return _guideId;
  }
  String getTitle(){
    return _title;
  }
  String? getLocation(){
    return _location;
  }
  double getLat(){
    return _lat;
  }
  double getLng(){
    return _lng;
  }
  String getDate1(){
    return _date1;
  }
  String getTime1(){
    return _time1;
  }
  String getDate2(){
    return _date2;
  }
  String getTime2(){
    return _time2;
  }
  List<String> getFoodChoices(){
    return _selFoodChoices;
  }
  List<String> getPlaceChoices(){
    return _selPlaceChoices;
  }
  List<String> getPrefChoices(){
    return _selPrefChoices;
  }
  List<Asset> getImages(){
    return _imageList;
  }
  List<String> getTags(){
    return _tagList;
  }
  String getEventId(){
    return _eventId;
  }
  String getState(){
    return _state;
  }
  double getLike(){
    return _like;
  }
  double getCount(){
    return _count;
  }


  Map<String, dynamic> toMap() => {
    'guideId': _guideId,
    'guideName': _guideName,
    'title': _title,
    'location': _location,
    'lat': _lat,
    'lng': _lng,
    'date1': _date1,
    'time1': _time1,
    'date2': _date2,
    'time2': _time2,
    'selFoodChoices': _selFoodChoices,
    'selPlaceChoices': _selPlaceChoices,
    'selPrefChoices': _selPrefChoices,
    'imageList': _imageList,
    'tagList': _tagList,
    'eventId': _eventId,
    'state': _state,
    'like': _like,
    'count': _count,
  };

  Event.fromJson(Map<String, dynamic> json)
  : _guideId = json['guideId'],
    _guideName = json['guideName'],
    _title = json['title'],
    _location = json['location'],
    _lat = json['lat'],
    _lng = json['lng'],
    _date1 = json['date1'],
    _time1 = json['time1'],
    _date2 = json['date2'],
    _time2 = json['time2'],
    _selFoodChoices = json['selFoodChoices'].cast<String>(),
    _selPlaceChoices = json['selPlaceChoices'].cast<String>(),
    _selPrefChoices = json['selPrefChoices'].cast<String>(),
    _imageList = json['imageList'].cast<Asset>(),
    _tagList = json['tagList'].cast<String>(),
    _eventId = json['eventId'],
    _state = json['state'],
    _like = json['like'],
    _count = json['count'];

}