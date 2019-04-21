import 'egg_timer.dart';
import 'egg_timer_controls.dart';
import 'egg_timer_dial.dart';
import 'package:flutter/material.dart';
import 'egg_timer_time_display.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerHome extends StatefulWidget {
  EggTimerHome({Key key, this.title}) : super(key: key);

  final String title;

  _EggTimerHomeState createState() => _EggTimerHomeState();
}

class _EggTimerHomeState extends State<EggTimerHome> {
  EggTimer eggTimer;

  _EggTimerHomeState() {
    eggTimer = new EggTimer(
      maxTime: const Duration(minutes: 60),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  //sets current time as the selected time
  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  //callback for when dial stops turning and time has been selected
  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  //refresh state when timer is updated
  _onTimerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                  EggTimerTimeDisplay(
                    eggTimerState: eggTimer.state,
                    selectionTime: eggTimer.lastStartTime,
                    countdownTime: eggTimer.currentTime,
                  ),

                  //from egg_timer_dial.dart, this widget handles the timer dial
                  EggTimerDial(
                    currentTime: eggTimer.currentTime,
                    maxTime: eggTimer.maxTime,
                    ticksPerSection: 5,
                    onTimeSelected: _onTimeSelected,
                    onDialStopTurning: _onDialStopTurning,
                    eggTimerState: eggTimer.state,
                  ),

                  Expanded(
                    child: Container(),
                  ),

                  //from egg_timer_controls.dart which contains the Restart, Reset and Pause buttons
                  EggTimerControls(
                    eggTimerState: eggTimer.state,
                    onPause: () {
                      setState(() {
                        eggTimer.pause();
                      });
                    },
                    onResume: () {
                      setState(() {
                        eggTimer.resume();
                      });
                    },
                    onRestart: () {
                      setState(() {
                        eggTimer.restart();
                      });
                    },
                    onReset: () {
                      setState(() {
                        eggTimer.reset();
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
