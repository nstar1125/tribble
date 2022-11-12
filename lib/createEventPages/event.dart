import 'package:multi_image_picker/multi_image_picker.dart';
class Event{
  String _date1 = "";
  String _time1 = "";
  String _date2 = "";
  String _time2 = "";
  List<String> _selectedChoices = [];
  List<Asset> _imageList = <Asset>[];
  List<String> _tagList = <String>[];

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

}