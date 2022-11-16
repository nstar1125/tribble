import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/chatPage.dart';
import 'package:tribble_guide/chatPages/chatDB/DatabaseService.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  //final String opponent;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String resentmessage = "";
  @override
  void initState() {
    super.initState();
    gettinggroup();
  }

  gettinggroup() async {
    await DatabaseService().getrecentmessage(widget.groupId).then((val) {
      setState(() {
        resentmessage = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    userName: widget.userName)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.jpeg"),
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            "가이드이름", //DB에서 가져옴
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            resentmessage,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
