import 'package:multi_image_picker/multi_image_picker.dart';
class Event{
  //String _guideId = "";
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _date1 = "";
  String _time1 = "";
  String _date2 = "";
  String _time2 = "";
  List<String> _selectedChoices = [];
  List<Asset> _imageList = <Asset>[];
  List<String> _tagList = <String>[];
  // like, isBooked, count

  // setGuideId(String id){
  //   _guideId = id;
  // }
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

  Map<String, dynamic> toJson() => {
    // 'guideId': _guideId,
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
  };
}