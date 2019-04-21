import 'package:egg_timer/egg_timer_button.dart';
import 'package:egg_timer/egg_timer_controls.dart';
import 'package:egg_timer/egg_timer_dial.dart';
import 'package:flutter/material.dart';
import 'egg_timer_time_display.dart';

import 'package:fluttery/animations.dart';
import 'package:fluttery/framing.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery/layout.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

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
          body: Container(

            //Top -> Bottom gradient color
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            )),
            child: Center(
              child: Column(
                children: <Widget>[

                  //from egg_timer_time_display.dart, this widget handles the time display
                  EggTimerTimeDisplay(),

                  //from egg_timer_dial.dart, this widget handles the timer dial
                  EggTimerDial(),

                  Expanded(
                    child: Container(),
                  ),

                  //from egg_timer_controls.dart which contains the Restart, Reset and Pause buttons
                  EggTimerControls()
                ],
              ),
            ),
          ),
        ));
  }
}
