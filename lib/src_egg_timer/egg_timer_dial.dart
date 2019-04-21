import 'egg_timer.dart';
import 'egg_timer_knob.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fluttery/gestures.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {

  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;
  final EggTimerState eggTimerState;

  EggTimerDial({
    Key key,
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.eggTimerState
  }) : super(key: key);

  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> with TickerProviderStateMixin{

  static const RESET_SPEED_PERCENT_PER_SECOND = 4.0;

  EggTimerState prevEggTimerState;
  double prevRotationPercent = 0.0;
  AnimationController resetToZeroController;
  Animation resettingAnimation;

  @override
  void initState() {
    super.initState();

    resetToZeroController = new AnimationController(vsync: this);
  }

  @override
  void dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  // percent rotation according to the current time
  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {

    if(widget.currentTime.inSeconds == 0
      && prevEggTimerState != EggTimerState.ready) {
        resettingAnimation = Tween(begin: prevRotationPercent, end: 0.0)
          .animate(resetToZeroController)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if(status == AnimationStatus.completed) {
              setState(() => resettingAnimation = null);
            }
          });
        resetToZeroController.duration = Duration(
          milliseconds: ((prevRotationPercent / RESET_SPEED_PERCENT_PER_SECOND) * 1000).round()
        );
        resetToZeroController.forward(from: 0.0);
      }

    prevRotationPercent = _rotationPercent();
    prevEggTimerState = widget.eggTimerState;

    return DialTurnGestureDetector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45.0),
          child: AspectRatio(
              aspectRatio: 1.0,

              //Outer Circle
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x44000000),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: const Offset(0.0, 1.0))
                    ]),

                //Inner Circle with time selector knob
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(55.0),
                      child: CustomPaint(
                        painter: TickPainter(
                          tickCount: widget.maxTime.inMinutes,
                          ticksPerSection: widget.ticksPerSection,
                        ),
                      ),
                    ),

                    //from egg_timer_knob.dart, creates the time selector knob widget
                    Padding(
                      padding: const EdgeInsets.all(65.0),
                      child: EggTimerDialKnob(
                        rotationPercent: resettingAnimation == null 
                        ? _rotationPercent()
                        : resettingAnimation.value,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class DialTurnGestureDetector extends StatefulWidget {

  final currentTime;
  final maxTime;
  final child;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  DialTurnGestureDetector({
    Key key, 
    this.child,
    this.currentTime,
    this.maxTime,
    this.onTimeSelected,
    this.onDialStopTurning,
  }) : super(key: key);

  _DialTurnGestureDetectorState createState() =>
      _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {

  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord) {
    if(startDragCoord != null) {

      //calculates the angle difference b/w start position and end position, wil be used when moving time selector.
      var andgleDiff = coord.angle - startDragCoord.angle;
      andgleDiff = andgleDiff >= 0.0 ? andgleDiff : andgleDiff + (2 * math.pi); //to make the angles positive
      final anglePercent = andgleDiff / (2 * math.pi);
      final timeDiffInSeconds = (anglePercent * widget.maxTime.inSeconds).round();
      selectedTime = Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);

      widget.onTimeSelected(selectedTime);
    }
  }


  _onRadialDragEnd() {
    widget.onDialStopTurning(selectedTime);

    startDragCoord = null;
    startDragTime = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    //RadialDialGestureDetector from Fluttery package, return polar coordinates w.r.t. center
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragEnd: _onRadialDragEnd,
      onRadialDragUpdate: _onRadialDragUpdate,
      child: widget.child,
    );
  }
}

class TickPainter extends CustomPainter {
  //Length of ticks constants
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  //defines the ticks per section and which ticks are long ticks, along with text properties
  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;
  final textPainter;
  final textStyle;

  //Sets default values and defines the tick painter
  TickPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;

    //we use strokeWidth because we need to draw lines
    tickPaint.strokeWidth = 1.5;
  }

  //We'll paint at a constant position, and rotate the canvas after each line paint till tickCounts.
  @override
  void paint(Canvas canvas, Size size) {
    //translate the canvas to the same position as the arrow
    canvas.translate(size.width / 2, size.height / 2);

    //saves the position for restoration after painting all ticks
    canvas.save();

    final radius = size.width / 2;

    //Continuously draws the ticks till all are drawn
    for (var i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;

      //draws a line from origin of the canvas upwards of SHORT_TICK length
      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius - tickLength), tickPaint);

      if (i % ticksPerSection == 0) {
        //Paint Text
        canvas.save();

        //positioning the canvas above the tick
        canvas.translate(0.0, -radius - 30.0);

        textPainter.text = new TextSpan(text: '$i', style: textStyle);

        //Layout the text
        textPainter.layout();

        //Figure out which quadrant the text is in (flutter quadrants go clockwise)
        final tickPercent = i / tickCount;
        var quadrant;
        if (tickPercent < 0.25)
          quadrant = 1;
        else if (tickPercent < 0.5)
          quadrant = 4;
        else if (tickPercent < 0.75)
          quadrant = 3;
        else
          quadrant = 2;

        //to rotate the text box canvas according to the quadrant
        switch (quadrant) {
          case 1:
            break;
          case 4:
            canvas.rotate(-math.pi / 2);
            break;
          case 2:
          case 3:
            canvas.rotate(math.pi / 2);
            break;
        }

        textPainter.paint(
            canvas,
            //offset used to align the text box according to the tick
            Offset(
              -textPainter.width / 2,
              -textPainter.height / 2,
            ));

        canvas.restore();
      }

      //rotating the canvas by the distance b/w 2 ticks
      canvas.rotate(2 * math.pi / tickCount);
    }

    //restoring canvas after rotating to draw all ticks
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
