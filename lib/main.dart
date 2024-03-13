import 'package:flutter/material.dart';
import 'package:messenger_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger_app/theme/light_mode.dart';
import 'firebase_options.dart';




void main() {
  runApp(const ChatApp());
}


class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: lightMode,
    );
  }
}
