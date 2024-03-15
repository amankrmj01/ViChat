import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 0, top:5, right: 5, left: 5),
      // alignment: Alignment.center,
      constraints: const BoxConstraints(minHeight: 40,minWidth:40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.isCurrentUser ? Color.lerp(Colors.amber, Colors.grey, 0.2):Color.lerp(Colors.amber, Colors.grey, 0.8),
      ),
      child: Text(widget.message,style: const TextStyle(fontSize: 20),),
    );
  }
}
