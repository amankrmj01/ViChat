import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // actions: [IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back))],
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
          'Settings',
          style: TextStyle(fontSize: 24),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0.4),
            systemNavigationBarColor:
                Color.lerp(Colors.white, Colors.black, 0.4)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }
}
