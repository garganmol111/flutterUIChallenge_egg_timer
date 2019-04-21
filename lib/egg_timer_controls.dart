import 'package:flutter/material.dart';
import 'egg_timer_button.dart';

class EggTimerControls extends StatefulWidget {
  EggTimerControls({Key key}) : super(key: key);

  _EggTimerControlsState createState() => _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //from egg_timer_button.dart, this will build the 3 buttons that we need. Parameters: Button Icon and Button Text
        Row(
          children: [
            //Restart button
            EggTimerButton(
              icon: Icons.refresh,
              text: 'RESTART',
            ),
            Expanded(
              child: Container(),
            ),
            //Reset button
            EggTimerButton(
              icon: Icons.arrow_back,
              text: 'RESET',
            )
          ],
        ),
        //Pause button
        EggTimerButton(
          icon: Icons.pause,
          text: 'PAUSE',
        )
      ],
    );
  }
}
