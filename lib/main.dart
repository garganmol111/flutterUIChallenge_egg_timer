import 'package:egg_timer/egg_timer_button.dart';
import 'package:egg_timer/egg_timer_controls.dart';
import 'package:flutter/material.dart';
import 'egg_timer_time_display.dart';

import 'package:fluttery/animations.dart';
import 'package:fluttery/framing.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery/layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                //from egg_timer_time_display.dart, this widget handles the time display
                new EggTimerTimeDisplay(),

                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 45.0, right: 45.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: RandomColorBlock(
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(),
                ),

                //from egg_timer_controls.dart which contains the Restart, Reset and Pause buttons.
                EggTimerControls()
              ],
            ),
          ),
        ));
  }
}
