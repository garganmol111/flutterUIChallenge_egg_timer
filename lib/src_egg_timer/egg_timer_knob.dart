import 'package:flutter/material.dart';
import 'dart:math' as math;

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDialKnob extends StatefulWidget {
  EggTimerDialKnob({Key key, this.rotationPercent}) : super(key: key);

  final rotationPercent;

  _EggTimerDialKnobState createState() => _EggTimerDialKnobState();
}

class _EggTimerDialKnobState extends State<EggTimerDialKnob> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Traingle selector arrow
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(
              rotationPercent: widget.rotationPercent,
            ),
          ),
        ),

        //Knob
        Container(
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

          //Innermost circle with border which contains logo
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDFDFDF),
                    width: 1.5,
                  )),
              child: Center(
                child: Transform(
                  //rotate the logo according to current time
                  transform: Matrix4.rotationZ(2 * math.pi * widget.rotationPercent),
                  alignment: Alignment.center,
                  child: Image.network(
                    //URL with flutter logo
                    'https://avatars3.githubusercontent.com/u/14101776?s=400&v=4',
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;

  //Used to define painter which will fill the traingle selector
  ArrowPainter({this.rotationPercent = 0}) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.black;

    //we use style because we need to draw a shape 
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //to save the canvas, we'll restore it afterwords
    canvas.save();

    final radius = size.height / 2;

    //sets the canvas at the center
    canvas.translate(radius, radius);
    
    //rotating canvas acording to current time
    canvas.rotate(2 * math.pi * rotationPercent);

    //This will create the lines required to draw the triangle
    Path path = new Path();
    path.moveTo(0.0, -radius - 10.0);
    path.lineTo(10.0, -radius + 5.0);
    path.lineTo(-10.0, -radius + 5.0);
    path.close();

    //This will draw the traingle by drawing all the paths and paint it with the dialArrowPaint we defined earlier.
    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 3.0, false);

    //to restore the canvas after tranlation
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
