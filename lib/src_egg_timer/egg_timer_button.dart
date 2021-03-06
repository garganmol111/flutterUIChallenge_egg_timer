import 'package:flutter/material.dart';

class EggTimerButton extends StatelessWidget {
  EggTimerButton({Key key, this.icon, this.text, this.onPressed, this.color}) : super(key: key);

  final IconData icon;
  final String text;
  final Function() onPressed;
  Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: const Color(0x22000000),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(icon, color: Colors.black),
            ),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0),
            )
          ],
        ),
      ),
      color: color,
    );
  }
}