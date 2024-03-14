import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_text_filed.dart';
import '../Main/mainScreen.dart';

class LoginDetails extends StatefulWidget {
  final void Function()? onTap;
  const LoginDetails({super.key, required this.onTap});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void showDialogWithText(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  logIN(String email, String password) async {
    if (email == "" || password == "") {
      showDialogWithText( 'Enter the details');
    } else {
      UserCredential? userCredentail;
      try {
        userCredentail = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) => MainScreen())));
      } on FirebaseAuthException catch (ex) {
        showDialogWithText('Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            controller: _email,
            text: 'Username',
            visible: false,
            icon: const Icon(Icons.person),
          ),
          const SizedBox(
            height: 30,
          ),
          MyTextField(
            controller: _password,
            text: 'Password',
            visible: true,
            icon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            statesController: MaterialStatesController(),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.withOpacity(0.3);
                    }
                    return Colors.amber;
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            onPressed: () {
              logIN(_email.text.toString(), _password.text.toString());
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 45, color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a member?',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: Colors.amber.withOpacity(0.1),
                onTap: widget.onTap,
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

