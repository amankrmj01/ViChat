import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_app/services/chat/chat_bubble.dart';
import 'package:messenger_app/services/chat/chat_services.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receivedEmail;
  final String receiverId;
  const ChatPage({super.key, required this.receivedEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if(focusNode.hasFocus)
        {
          Future.delayed(const Duration(milliseconds: 500),()=> scrollDown(),);
        }
    });
    Future.delayed(const Duration(milliseconds: 100),()=> scrollDown(),);

  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    focusNode.dispose();
  }

  final ScrollController scrollController = ScrollController();

  void scrollDown(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  final TextEditingController _messageController = TextEditingController();

  final ChatServices _chatServices = ChatServices();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverId, _messageController.text.toString());
      _messageController.clear();
    }
    scrollDown();
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
          widget.receivedEmail,
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
              width: double.infinity,
              margin: const EdgeInsets.only(top:8),
              padding: const EdgeInsets.only(top: 2),
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
      stream: _chatServices.getMessage(widget.receiverId, senderID),
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          controller: scrollController,
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

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: alignment,
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
      ),
    ),
  );
}

  Widget _userInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            // onTapOutside: (event) {
            //   FocusManager.instance.primaryFocus!.unfocus();
            // },
            controller: _messageController,
            decoration: InputDecoration(
                hintText: 'Type a Message',
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.amber)),
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
