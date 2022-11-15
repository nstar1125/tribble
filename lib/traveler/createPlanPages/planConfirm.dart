import 'package:flutter/material.dart';
import 'package:tribble_guide/guide/createEventPages/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlanConfirmPage extends StatefulWidget {
  const PlanConfirmPage({Key? key}) : super(key: key);

  @override
  State<PlanConfirmPage> createState() => _PlanConfirmPageState();
}

class _PlanConfirmPageState extends State<PlanConfirmPage> {
  late GoogleMapController _controller;
  final Set<Marker> markers = {};

  int peanut_count = 0;
  int eventCount = 3;
  List<bool> pickList = [true, true, true];
  List<bool> showList = [false, false, false];

  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    });
  }
  flagToPt(bool flag){
    if(flag){
      return 2;
    }else{
      return 1;
    }
  }
  getShowCount(){
    int count = 0;
    for(int i=0; i<showList.length; i++)
      showList[i] ? count ++ : null;
    return count;
  }

  getTotalPt(List<bool> pList){
    int sum = 0;
    pList.forEach((element) {
      if(element){
        sum += 2;
      }else{
        sum += 1;
      }
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    //List<Event> eventList = ModalRoute.of(context)!.settings.arguments as List<Event>;
    List<Row> r = [];

    //Event e = ModalRoute.of(context)!.settings.arguments as Event;
    //addMarker(LatLng(e.getLat(), e.getLng()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap:() {
              setState(() {
                peanut_count++;
              });
            },
            child: Container(
                child: Row(
                  children: [
                    Image(image: AssetImage("assets/images/peanut.png"),width: 20,),
                    SizedBox(width: 3),
                    Text("${peanut_count}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily:"GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(width:20)
                  ],
                )
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                  width:3,
                  height: showList[showList.length-1] ?
                    100*eventCount.toDouble()+300*(getShowCount()-1) :
                    100*eventCount.toDouble()+300*getShowCount(),
                  color: Colors.lightBlueAccent
              ),
            ),
            Column(
              children: [
                Container(
                    height: 100*(eventCount.toDouble()+1)+300*getShowCount(),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: eventCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showList[index] ?
                                    showList[index] = false :
                                    showList[index] = true;
                                    print(showList);
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:10, right:10),
                                              child: Container(
                                                  color: Colors.white,
                                                  child: Icon(Icons.circle_outlined,
                                                    color: Colors.lightBlueAccent,)),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Text("Title1",
                                                  style: TextStyle(
                                                      fontFamily: "GmarketSansTTF",
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Text("10.11 11:30 ~ 10.11 13:30",
                                                  style: TextStyle(
                                                    fontFamily: "GmarketSansTTF",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Switch(
                                                value: pickList[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    pickList[index] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 6),
                                                    Image(image: AssetImage("assets/images/peanut.png"),width: 12,),
                                                    SizedBox(width: 3),
                                                    Text(flagToPt(pickList[index]).toString(),
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontFamily:"GmarketSansTTF",
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    ),
                                                    SizedBox(width:20)
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                              showList[index] ?
                                  Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width-80,
                                    child: Column(
                                      children: [

                                        Container(
                                          height: 150,
                                          color: Colors.lightGreenAccent
                                        ),
                                        SizedBox(height: 20),
                                        Text("위치 정보 위치 정보 위치 정보 위치 정보",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("설명 설명 설명 설명 설명 설명 설명 설명 설명 ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("주제 주제 주제 주제 주제 주제 ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 20),
                                        Text("작성자 ㅇㅇㅇ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 14,
                                            )),



                                      ],
                                    ),


                                  ) :
                                  Container()



                            ],
                          );
                        }
                    )
                ),


                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    onPressed: (){

                    },
                    icon: Image(image: AssetImage("assets/images/peanut.png"),width: 20,),
                    label: Text("(${getTotalPt(pickList)}) Confirm my plan",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ))
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
