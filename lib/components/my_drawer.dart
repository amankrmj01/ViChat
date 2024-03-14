import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messenger_app/components/my_logo.dart';
import 'package:messenger_app/pages/settings.dart';

import '../pages/Main/auth_gate.dart';

class DrawerC extends StatelessWidget {
  const DrawerC({super.key});
  @override
  Widget build(BuildContext context) {
    List items = [
      [const Text('Home'), Icons.home,(){Navigator.pop(context);}],
      [const Text('Profile'), Icons.person_3_sharp,(){}],
      [
        const Text('Settings'),
        Icons.settings,
        () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => Settings()));
        }
      ],
    ];
    return Container(
      padding: EdgeInsets.only(top: 26),
      margin: EdgeInsets.zero,
      child: Drawer(
        backgroundColor: Colors.amber.shade300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 75,
              child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(left: 10, bottom: 4, top: 0),
                  child: Row(
                    children: [
                      MyLogo(
                        size: 0,
                      ),
                      Text(
                        'Menu',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: items[index][2],
                      title: items[index][0],
                      leading: Icon(items[index][1]),
                    );
                  }),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AuthGate()));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded),
                    Text('LogOut'),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
