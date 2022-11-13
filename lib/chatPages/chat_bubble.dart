import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, this.isMe, {Key? key}) : super(key: key);

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          //말풍선 모서리 깍는 부분.
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0)),
          ),
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text(
            message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
          ),
        ),
      ],
    );
  }
}
