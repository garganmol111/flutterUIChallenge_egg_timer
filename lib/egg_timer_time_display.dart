import 'package:egg_timer/egg_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EggTimerTimeDisplay extends StatefulWidget {

  final eggTimerState;
  final selectionTime;
  final countdownTime;

  EggTimerTimeDisplay({
    Key key, 
    this.eggTimerState,
    this.countdownTime = const Duration(seconds: 0),
    this.selectionTime = const Duration(seconds: 0),
  }) : super(key: key);

  @override
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> with TickerProviderStateMixin{

  final DateFormat selectionTimeFormat = new DateFormat('mm');
  final DateFormat countdownTimeFormat = new DateFormat('mm:ss');

  //Animation Controllers to control the animation of selection time and countdown time
  AnimationController selectionTimeSlideController;
  AnimationController countdownTimeFadeController;

  @override
  void initState() {
    super.initState();

    selectionTimeSlideController = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    )
    ..addListener(() {
      setState(() {});
    });

    countdownTimeFadeController = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    )
    ..addListener(() {
      setState(() {});
    });
    countdownTimeFadeController.value = 1.0;
  }

  @override 
  void dispose() {
    selectionTimeSlideController.dispose();
    countdownTimeFadeController.dispose();
    super.dispose();
  }

  //used to format the selectionTime and countdownTime text
  get formattedSelectionTime {
    DateTime dateTime = new DateTime(new DateTime.now().year, 0, 0, 0, 0, widget.selectionTime.inSeconds);
    return selectionTimeFormat.format(dateTime);
  }

  get formatCountdownTime {
    DateTime dateTime = new DateTime(new DateTime.now().year, 0, 0, 0, 0, widget.countdownTime.inSeconds);
    return countdownTimeFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    if(widget.eggTimerState == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
      countdownTimeFadeController.forward();
    } else {
      selectionTimeSlideController.forward();
      countdownTimeFadeController.reverse();
    }

    return new Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          //Timer setter text, slides out of screen when time set
          Transform(
            transform: new Matrix4.translationValues(
              0.0, 
              -200.0 * selectionTimeSlideController.value, 
              0.0
            ),
            child: Text(
              formattedSelectionTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 150.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0),
            ),
          ),

          //Timer current text, fades into the screen when timer starts
          Opacity(
            opacity: 1.0 - countdownTimeFadeController.value,
            child: Text(
              formatCountdownTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 150.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
