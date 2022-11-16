import 'package:multi_image_picker/multi_image_picker.dart';

Map<String, dynamic> initEvent = {
  'guideId': "",
  'title': "",
  'location': "",
  'lat': 0.0,
  'lng': 0.0,
  'date1': "",
  'time1': "",
  'date2': "",
  'time2': "",
  'selectedChoices': <String>[],
  'imageList': <Asset>[],
  'tagList': <String>[],
  'eventId': "",
  'isBooked': false,
  'like': 0.0,
  'count': 0.0
};

class Event{
  String _guideId = "";
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _date1 = "";
  String _time1 = "";
  String _date2 = "";
  String _time2 = "";
  List<String> _selectedChoices = <String>[];
  List<Asset> _imageList = <Asset>[];
  List<String> _tagList = <String>[];

  String _eventId = "";
  bool _isBooked = false;
  double _like = 0.0;
  double _count = 0.0;
  // like, isBooked, count

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
  setChoices(List<String> arr){
    _selectedChoices = arr;
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
  setIsBooked(bool book){
    _isBooked = book;
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
  List<String> getChoices(){
    return _selectedChoices;
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
  bool getIsBooked(){
    return _isBooked;
  }
  double getLike(){
    return _like;
  }
  double getCount(){
    return _count;
  }


  Map<String, dynamic> toMap() => {
    'guideId': _guideId,
    'title': _title,
    'location': _location,
    'lat': _lat,
    'lng': _lng,
    'date1': _date1,
    'time1': _time1,
    'date2': _date2,
    'time2': _time2,
    'selectedChoices': _selectedChoices,
    'imageList': _imageList,
    'tagList': _tagList,

    'eventId': _eventId,
    'isBooked': _isBooked,
    'like': _like,
    'count': _count,
  };

  Event.fromJson(Map<String, dynamic> json)
  : _guideId = json['guideId'],
    _title = json['title'],
    _location = json['location'],
    _lat = json['lat'],
    _lng = json['lng'],
    _date1 = json['date1'],
    _time1 = json['time1'],
    _date2 = json['date2'],
    _time2 = json['time2'],
    _selectedChoices = json['selectedChoices'].cast<String>(),
    _imageList = json['imageList'].cast<Asset>(),
    _tagList = json['tagList'].cast<String>(),
    _eventId = json['eventId'],
    _isBooked = json['isBooked'],
    _like = json['like'],
    _count = json['count'];

}