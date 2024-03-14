import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/my_text_filed.dart';
import '../Main/mainScreen.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _gmail = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  void register(TextEditingController username, TextEditingController password,
      TextEditingController gmail) {
    if (_username.text.isEmpty &&
        _gmail.text.isEmpty &&
        _password.text.isEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            controller: _username,
            text: 'Username',
            visible: false,
            icon: const Icon(Icons.person),
          ),
          const SizedBox(
            height: 30,
          ),
          MyTextField(
            controller: _gmail,
            text: 'Gmail',
            visible: false,
            icon: const Icon(Icons.alternate_email_outlined),
          ),
          const SizedBox(
            height: 30,
          ),
          MyDropdown(),
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
          MyTextField(
            controller: _confirmPassword,
            text: 'Password',
            visible: true,
            icon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              addUserDetails(_username.text.toString(), _MyDropdownState.dropdownValue, _gmail.text.toString(), _password.text.toString());
            },
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
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 45, color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already a member?',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: Colors.amber.withOpacity(0.1),
                onTap: widget.onTap,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  signUp(String email, String password) async {
    UserCredential? userCredentail;
    try {
      userCredentail = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => MainScreen())));
    } on FirebaseAuthException catch (ex) {
      showDialogWithText( 'Error');
    }
  }

  Future addUserDetails(
      String username, String gender, String email, String password) async {
    if (username == "" ||
        gender == "" ||
        email == "" ||
        password == "") {
      showDialogWithText( 'Fill all the required Details');
    } else {
      signUp(email, password);
      await FirebaseFirestore.instance.collection('Users').add({
        'username': username,
        'gender': gender,
        'email': email
      });
    }
  }

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

}



class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  static String dropdownValue = 'Gender';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <String>['Male', 'Female'].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }).toList();
      },
      onSelected: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black),
        // Set the shape here
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints.expand(width: width - 40, height: 120),
      padding: const EdgeInsets.all(50),

      child: Container(
          height: 60,
          // width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 1)),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dropdownValue,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ))), // Set the width and height here
    );
  }
}