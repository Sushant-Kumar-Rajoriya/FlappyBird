import 'package:flutter/material.dart';

class MyCoverScreen extends StatefulWidget {
  final bool gameHasStarted;

  MyCoverScreen({
    required this.gameHasStarted,
  });

  @override
  _MyCoverScreenState createState() => _MyCoverScreenState();
}

class _MyCoverScreenState extends State<MyCoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.5),
      child: Text(
        widget.gameHasStarted ? '' : 'T A P  T O  P L A Y',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
