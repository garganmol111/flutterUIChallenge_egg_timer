import 'package:egg_timer/egg_timer_knob.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  EggTimerDial({Key key}) : super(key: key);

  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      painter: TickPainter(),
                    ),
                  ),

                  //from egg_timer_knob.dart, creates the time selector knob widget
                  Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: EggTimerKnob(),
                  ),
                ],
              ),
            )),
      ),
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
