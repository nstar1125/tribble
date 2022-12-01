import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AutoPlanPage extends StatefulWidget {
  const AutoPlanPage({Key? key}) : super(key: key);

  @override
  State<AutoPlanPage> createState() => _AutoPlanPageState();
}

class _AutoPlanPageState extends State<AutoPlanPage> {
  List<String> foodList = [
    "🍽 Meal",
    "🍺 Beer",
    "☕️ Cafe",
    "🏮 Local market",
  ];
  List<String> placeList = [
    "⛰ Landscape",
    "🏯 Traditional place",
    "🛍 Shopping",
    "🪂 Activity",
    "🏟 Sports",
    "🎨 Arts",
    "🎯 Entertainment",
    "🧖 Relax",
    "🚶 Walk",
  ];
  List<String> prefList = [
    "🎎 Only local",
    "🔥 Hot place",
    "📷 Photo spot",
    "🤳 alone",
    "🎈 Young",
    "😌 Leisurely"
  ];
  List<List<String>> bias = [];
  List<String> _selFoodChoices = [];
  List<String> _selPlaceChoices = [];
  List<String> _selPrefChoices = [];
  String _date1 = "Choose Date";

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(
          "Travel Preference",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.fastfood),
                Text(" Food",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ]),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: _buildChoiceList(1), //타입 1: food, 2: place, 3: pref
            ),
          ),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.category),
                Text(" Place Category",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ]),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: _buildChoiceList(2), //타입 1: food, 2: place, 3: pref
            ),
          ),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.emoji_emotions),
                Text(" Characteristic",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ]),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: _buildChoiceList(3), //타입 1: food, 2: place, 3: pref
            ),
          ),
          SizedBox(height: 20),
          Row(                                                  //시간
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.access_time_filled),
                Text(" Time",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 13,
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
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.lightBlueAccent,
              ),
              onPressed: () {
                bias.add(_selFoodChoices);
                bias.add(_selPlaceChoices);
                bias.add(_selPrefChoices);
                Navigator.of(context).pushNamed('/toShowNomiPage', arguments: bias);
              },
              icon: Icon(Icons.search),
              label: Text("find recommended plans",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
