import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_logo.dart';
import 'package:messenger_app/pages/settings.dart';

import '../pages/Main/auth_gate.dart';

class DrawerC extends StatelessWidget {
  const DrawerC({super.key});
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    // double? statusBarHeight = Get.statusBarHeight;
    List items = [
      [
        const Text('Home'),
        Icons.home,
        () {
          Navigator.pop(context);
        }
      ],
      [const Text('Profile'), Icons.person_3_sharp, () {}],
      [
        const Text('Settings'),
        Icons.settings,
        () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => Settings()));
        }
      ],
    ];
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight ?? 36),
      // margin: EdgeInsets.zero,
      child: Drawer(
        backgroundColor: Colors.amber.shade300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 75,
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.zero,
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyLogo(
                    size: 0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Menu',
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
              color: Color.lerp(Colors.amber, Colors.black, 0.2),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(5),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
