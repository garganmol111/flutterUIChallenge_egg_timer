import 'package:flutter/material.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  EggTimerTimeDisplay({Key key}) : super(key: key);

  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Text(
        '15:23',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'BebasNeue',
            fontSize: 150.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0),
      ),
    );
  }
}
