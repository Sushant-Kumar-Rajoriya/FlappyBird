import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;
  String birdImage;
  MyBird(
      {required this.birdImage,
      this.birdY,
      required this.birdWidth,
      required this.birdHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        birdImage,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        width: MediaQuery.of(context).size.width * birdWidth / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
