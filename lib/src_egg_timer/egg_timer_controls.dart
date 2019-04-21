import 'egg_timer.dart';
import 'package:flutter/material.dart';
import 'egg_timer_button.dart';

class EggTimerControls extends StatefulWidget {

  final eggTimerState;
  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;

  EggTimerControls({
    Key key,
    this.eggTimerState,
    this.onPause,
    this.onReset,
    this.onRestart,
    this.onResume
  }) : super(key: key);

  _EggTimerControlsState createState() => _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls> with TickerProviderStateMixin{

  //Animation controllers to control the buttons
  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();

    pauseResumeSlideController = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    )
    ..addListener(() => setState(() {}));
    pauseResumeSlideController.value = 0.0;

    restartResetFadeController = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    )
    ..addListener(() => setState(() {}));
    restartResetFadeController.value = 0.0;
  }

  @override
  void dispose() {
    pauseResumeSlideController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    switch (widget.eggTimerState) {
      case EggTimerState.ready:
        pauseResumeSlideController.forward();
        restartResetFadeController.forward();
        break;
      case EggTimerState.running:
      pauseResumeSlideController.reverse();
        restartResetFadeController.forward();
        break;
      case EggTimerState.paused:
      pauseResumeSlideController.reverse();
        restartResetFadeController.reverse();
        break;
    }

    return Column(
      children: <Widget>[

        //from egg_timer_button.dart, this will build the 3 buttons that we need. Parameters: Button Icon and Button Text
        Opacity(
          opacity: 1.0 - restartResetFadeController.value,
          child: Row(
            children: [

              //Restart button
              EggTimerButton(
                icon: Icons.refresh,
                text: 'RESTART',
                onPressed: widget.onRestart,
              ),

              Expanded(child: Container()),

              //Reset button
              EggTimerButton(
                icon: Icons.arrow_back,
                text: 'RESET',
                onPressed: widget.onReset,
              )
            ],
          ),
        ),

        //Pause button
        Transform(
          transform: Matrix4.translationValues(
            0.0, 
            100 * pauseResumeSlideController.value, 
            0.0
          ),
          child: EggTimerButton(
            icon: widget.eggTimerState == EggTimerState.running 
            ? Icons.pause
            : Icons.play_arrow,
            text: widget.eggTimerState == EggTimerState.running 
            ? "PAUSE"
            : "RESUME",
            onPressed: widget.eggTimerState == EggTimerState.running
            ? widget.onPause
            : widget.onResume,
          ),
        )
      ],
    );
  }
}
