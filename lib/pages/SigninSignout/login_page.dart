import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_logo.dart';
import 'package:messenger_app/pages/SigninSignout/login_details.dart';
import 'package:messenger_app/pages/SigninSignout/register_page.dart';

import '../clip_shadow.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLogin = true;
  bool isNull(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        // padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Stack(
          children: [
            ClipShadowPath(
              clipper: Upper(),
              shadow: BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                  spreadRadius: 5),
              child: Container(
                color: Colors.amber,
              ),
            ),
            ClipShadowPath(
              clipper: Bottom(),
              shadow: BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -10),
                  spreadRadius: 5),
              child: Container(
                color: Colors.amber,
              ),
            ),
            Positioned(
              child: MyLogo(size: 150,),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              margin: EdgeInsets.only(top: 300),
              height: 400,
              child: showLogin
                  ? LoginDetails(onTap: toggle)
                  : RegisterPage(
                      onTap: toggle,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class Upper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0314388, size.height * -0.0179672);
    path_0.quadraticBezierTo(size.width * -0.0353631, size.height * 0.2037198,
        size.width * -0.0366713, size.height * 0.2776155);
    path_0.cubicTo(
        size.width * 0.2124461,
        size.height * 0.3598058,
        size.width * 0.3790738,
        size.height * 0.2033761,
        size.width * 0.7045589,
        size.height * 0.2239982);
    path_0.quadraticBezierTo(size.width * 0.9342639, size.height * 0.2427871,
        size.width * 1.0281342, size.height * 0.3558418);
    path_0.lineTo(size.width * 1.0516803, size.height * 0.3566667);
    path_0.lineTo(size.width * 1.0647615, size.height * -0.0191129);
    path_0.lineTo(size.width * -0.0314388, size.height * -0.0179672);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Bottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * 1.0223500, size.height * 1.0550111);
    path_1.quadraticBezierTo(size.width * 1.0261250, size.height * 0.9747444,
        size.width * 1.0274250, size.height * 0.9479889);
    path_1.cubicTo(
        size.width * 0.7861750,
        size.height * 0.9182333,
        size.width * 0.6248250,
        size.height * 0.9748778,
        size.width * 0.3096750,
        size.height * 0.9674000);
    path_1.quadraticBezierTo(size.width * 0.0872500, size.height * 0.9606000,
        size.width * -0.0036750, size.height * 0.9196778);
    path_1.lineTo(size.width * -0.0264750, size.height * 0.9193667);
    path_1.lineTo(size.width * -0.0391500, size.height * 1.0554333);
    path_1.lineTo(size.width * 1.0223500, size.height * 1.0550111);
    path_1.close();

    return path_1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
