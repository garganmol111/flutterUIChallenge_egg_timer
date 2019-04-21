import 'dart:async';

class EggTimer {

  final Duration maxTime;
  final Function onTimerUpdate;
  final Stopwatch stopwatch = new Stopwatch();
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;
 
  EggTimer({
    this.maxTime,
    this.onTimerUpdate
  });
  
  get currentTime {
    return _currentTime;
  }

  //can only set time when timer is ready
  set currentTime(newTime) {
    if(state == EggTimerState.ready) {
      _currentTime = newTime;
      lastStartTime = _currentTime;
    }
  }

  //resumes the timer from it's previous position
  resume() {
    state = EggTimerState.running;
    
    stopwatch.start();

    _tick();
  }

  //pauses the timer
  pause() {

  }

  //run a second from current, recompute the current time
  _tick() {
    _currentTime = lastStartTime - stopwatch.elapsed;

    

    if(_currentTime.inSeconds > 0) {
      new Timer(const Duration(seconds: 1), _tick);
    } else {
      state = EggTimerState.ready;
    }

    if(onTimerUpdate != null) {
      onTimerUpdate();
    }
  }
}
 
enum EggTimerState {
  ready,
  running,
  paused,
}