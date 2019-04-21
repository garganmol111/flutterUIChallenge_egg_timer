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
    }
  }

  resume() {
    state = EggTimerState.running;
    lastStartTime = _currentTime;
    stopwatch.start();

    _tick();
  }

  pause() {

  }

  //run a second from current, recompute the current time
  _tick() {
    print('current time: ${_currentTime.inSeconds}');
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