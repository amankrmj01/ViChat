import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_app/services/chat/chat_bubble.dart';
import 'package:messenger_app/services/chat/chat_services.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  final String receivedEmail;
  final String receiverId;
  ChatPage({super.key, required this.receivedEmail, required this.receiverId});

  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          receiverId, _messageController.text.toString());
      _messageController.clear();
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();

    var formatter = DateFormat('hh:mm a');
    String formattedDate = formatter.format(date);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: const Offset(0, 5))
            ],
            gradient: LinearGradient(
              colors: [Colors.amber, Colors.red.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: const GradientRotation(160),
            ),
          ),
        ),
        title: Text(
          receivedEmail,
          style: const TextStyle(fontSize: 24),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0.4),
            systemNavigationBarColor:
                Color.lerp(Colors.white, Colors.black, 0.4)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: _buildMessageList(),
            ),
          ),
          Container(padding: const EdgeInsets.all(5), child: _userInput())
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _firebaseAuth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessage(receiverId, senderID),
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool currentUser = data['senderID'] == _firebaseAuth.currentUser!.uid;
    var alignment = currentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      // alignment: alignment,

      // constraints: const BoxConstraints(minHeight: 60, minWidth: 50),
      // padding: const EdgeInsets.all(8),
      // margin: const EdgeInsets.only(bottom: 5, top: 3, right: 5, left: 5),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   color: Colors.amber,
      // ),
      // color: Colors.blue.withOpacity(0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            currentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: currentUser),
          Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(formatTimestamp(data['timestamp']))),
        ],
      ),
    );
  }

  Widget _userInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            controller: _messageController,
            decoration: InputDecoration(
                hintText: 'Enter Message',
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.amber)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
          ),
        ),
        Transform.rotate(
            angle: 6,
            child: IconButton(
                padding: EdgeInsets.zero,
                enableFeedback: true,
                onPressed: sendMessage,
                icon: const Icon(Icons.send, size: 35)))
      ],
    );
  }
}
