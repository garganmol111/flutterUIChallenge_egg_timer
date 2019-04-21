import 'package:flutter/material.dart';
import 'src_egg_timer/home_egg_timer.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Egg Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EggTimerHome(title: 'Egg Timer Home Page'),
    );
  }
}
