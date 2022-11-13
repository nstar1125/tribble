import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:tribble_guide/createEventPages/event.dart';

class EventDetailCheckPageT extends StatefulWidget {
  const EventDetailCheckPageT({Key? key}) : super(key: key);

  @override
  State<EventDetailCheckPageT> createState() => _EventDetailCheckPageTState();
}

// 클릭한 이벤트의 상세 내용을 볼 수 있는 페이지입니다
// 구글맵 추가 완료
class _EventDetailCheckPageTState extends State<EventDetailCheckPageT> {
  late GoogleMapController _controller;
  final Set<Marker> markers = {};

  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Event e = ModalRoute.of(context)!.settings.arguments as Event;
    addMarker(LatLng(e.getLat(), e.getLng()));

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black87
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(e.getLat(), e.getLng()),
                    zoom: 15.0,
                  ),
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                ),
              ),
              Row(                                                  //제목
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.menu_book),
                    Text(" 제목",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ]
              ),
              Padding(                                                  //위치 정보
                padding: const EdgeInsets.only(left:20, right:20),
                child: Text(e.getTitle(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
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
              SizedBox(height:10),
              Padding(                                                  //위치 정보
                padding: const EdgeInsets.only(left:20, right:20),
                child: Text(e.getLocation()!,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
              ),
              SizedBox(height:30),
              Row(                                                  //일정시작
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time_filled),
                    Text(" 시간",
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
              Padding(                                                  //위치 정보
                padding: const EdgeInsets.only(left:20, right:20),
                child: Column(
                  children: [
                    Text(e.getDate1()+" "+e.getTime1(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        )),
                    SizedBox(height:10),
                    Text(e.getDate2()+" "+e.getTime2(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        )),
                  ],
                ),
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
              SizedBox(height:10),
              Container(
                height: e.getChoices().length*30,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: e.getChoices().length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                              "${e.getChoices()[index]}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              )
                          ),
                        ),
                      );
                    }),
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
              SizedBox(height:10),
              e.getImages().isEmpty                                   //이미지 리스트뷰
                  ? Container(
                child: Text("등록된 이미지가 없습니다.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
              )
                  : Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: e.getImages().length,
                    itemBuilder: (BuildContext context, int index) {
                      Asset asset = e.getImages()[index];
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AssetThumb(
                            asset: asset, width: 300, height: 300),
                      );
                    }),
              ),
              SizedBox(height:30),
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
              e.getTags().isEmpty                                   //주제 리스트뷰
                  ? Container(
                child: Text("등록된 주제가 없습니다.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
              )
                  : Container(
                height: e.getTags().length*30,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: e.getTags().length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                              "${e.getTags()[index]}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              )
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height:20),
              Center(
                child: ElevatedButton(
                  child: Text("Add To My Tour",
                    style: TextStyle(
                      fontFamily: "GmarketSansTTF",
                    ),),
                  onPressed: () {
                    Navigator.of(context).pop(e);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
