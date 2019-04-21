import 'package:flutter/material.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerKnob extends StatefulWidget {
  EggTimerKnob({Key key}) : super(key: key);

  _EggTimerKnobState createState() => _EggTimerKnobState();
}

class _EggTimerKnobState extends State<EggTimerKnob> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Traingle selector arrow
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(),
          ),
        ),

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
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;

  //Used to define painter which will fill the traingle selector
  ArrowPainter() : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.black;

    //we use style because we need to draw a shape 
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //to save the canvas, we'll restore it afterwords
    canvas.save();

    //sets the canvas at middle of the screen from x and 0 from y (origin is at the top of inner dial),
    //this will be the location where we want to paint the traingle which will function as the time selector.
    canvas.translate(size.width / 2, 0.0);

    //This will create the lines required to draw the triangle
    Path path = new Path();
    path.moveTo(0.0, -10.0);
    path.lineTo(10.0, 5.0);
    path.lineTo(-10.0, 5.0);
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
