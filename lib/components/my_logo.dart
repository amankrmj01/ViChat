import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  final double size;
  const MyLogo({super.key,required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 100, bottom: 30),
      margin: size !=0? const EdgeInsets.only(top: 100): const EdgeInsets.all(0),
      height: size!=0? size:45,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(83, 109, 254, 1),
            Color.fromRGBO(255, 87, 34, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Image.asset(
        'assets/logo/logo.png',
        height: size!=0? size:45,
      ),
    );
  }
}
