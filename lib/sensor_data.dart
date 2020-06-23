import 'dart:async';
import 'package:sensors/sensors.dart';

class SensorData {
  //
  //Variables
  //
  static List<messWerte> userAccelerometerValues = [];
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<String> userAccelerometer;
  Stopwatch watch = Stopwatch();

  //
  //Constructor
  //
  SensorData();

  //
  //Methods
  //
  void startDataStream() {
    watch.start();
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      messWerte messi = messWerte(
          time: watch.elapsedMilliseconds * 0.001,
          x: event.x,
          y: event.y,
          z: event.z);
      userAccelerometerValues.add(messi);
    }));
  }

  void stopDataStream() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      watch.stop();
    }
  }
}

class messWerte {
  double time, x, y, z;

  messWerte({this.time, this.x, this.y, this.z});
}
