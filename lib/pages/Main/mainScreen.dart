import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_app/components/my_drawer.dart';
import 'package:messenger_app/pages/Main/auth_gate.dart';
import 'package:messenger_app/services/chat/chat_services.dart';

import '../../components/userTile.dart';
import '../../services/chat/chatPage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ChatServices _chatServices = ChatServices();
  final AuthGate _authGate = const AuthGate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerC(),
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
        title: const Text(
          'VChat',
          style: TextStyle(fontSize: 24),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0.4),
            systemNavigationBarColor:
                Color.lerp(Colors.white, Colors.black, 0.4)),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 5, left: 3, right: 3),
          padding: EdgeInsets.symmetric(horizontal: 3),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber.withOpacity(0.1)),
          child: _buildingUserLists()),
    );
  }

  Widget _buildingUserLists() {
    return StreamBuilder(
        stream: _chatServices.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildingUser(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildingUser(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _getCurrentUser()) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ChatPage(
                        receivedEmail: userData['email'],
                    receiverId: userData['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }

  String? _getCurrentUser() {
    return FirebaseAuth.instance.currentUser!.email;
  }
}
