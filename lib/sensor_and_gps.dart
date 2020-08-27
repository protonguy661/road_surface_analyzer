import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

String csvPath;
File dataFile;
List<MeasuredDataObject> geoData = [];
bool shouldTrack = false;

class SensorData {
  List<MeasuredDataObject> accData = [];

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  Stopwatch watch = Stopwatch();

  ///=====Starting the accelerometer recording==================================
  startDataStream() async {
    shouldTrack = true;
    accData = [];

    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.LINEAR_ACCELERATION,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    _streamSubscriptions.add(stream.listen((sensorEvent) {
      watch.start();
      MeasuredDataObject measuredData = MeasuredDataObject(
        time: watch.elapsedMilliseconds * 0.001,
        x: sensorEvent.data[0],
        y: sensorEvent.data[1],
        z: sensorEvent.data[2],
      );

      accData.add(measuredData);
    }));
  }

  ///===========================================================================

  ///===========Stopping the accelerometer recording============================
  List<MeasuredDataObject> stopDataStream() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      watch.stop();
      shouldTrack = false;
      print('Amount of Geopoints ${geoData.length}');
    }
    _streamSubscriptions.clear();
    return accData;
  }

  ///===========================================================================

  ///===========Recording the GPS coordinates of the device=====================
  trackPosition() async {
    geoData = [];
    while (shouldTrack == true) {
      MeasuredDataObject measuredData = MeasuredDataObject(
        position: await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        time: watch.elapsed.inSeconds.toDouble(),
      );
      geoData.add(measuredData);
    }
  }

  ///===========================================================================
}

class MeasuredDataObject {
  double time, x, y, z;
  Position position;

  MeasuredDataObject({this.time, this.x, this.y, this.z, this.position});
}
