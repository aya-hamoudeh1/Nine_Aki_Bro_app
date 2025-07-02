import 'package:flutter/cupertino.dart';

class CustomOnBoardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double normalRadius = 100.0;
    double stretchedRadius = 8;

    Path path = Path()
      ..moveTo(0, normalRadius)
      ..quadraticBezierTo(0, 0, normalRadius, 0)
      ..lineTo(size.width - normalRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, normalRadius)
      ..lineTo(size.width, size.height - normalRadius)
      ..quadraticBezierTo(size.width, size.height, size.width - normalRadius, size.height)
      ..lineTo(normalRadius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - stretchedRadius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}