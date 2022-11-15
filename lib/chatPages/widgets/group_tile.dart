import 'package:flutter/material.dart';
import 'package:tribble_guide/chatPages/chatPage.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
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
            // child: Text(
            //   "1",
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(
            //       color: Colors.white, fontWeight: FontWeight.w500),
            // ),
          ),
          title: Text(
            widget.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "last message",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
