import 'dart:async';
import 'dart:io';
import 'package:sensors/sensors.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

String csvPath;

class SensorData {
  ///VARIABLES

  List<MeasuredDataObject> accData = [];
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  Stopwatch watch = Stopwatch();

  ///METHODS
  startDataStream() {
    accData = [];
    watch.start();
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      MeasuredDataObject measuredData = MeasuredDataObject(
          time: watch.elapsedMilliseconds * 0.001,
          x: event.x,
          y: event.y,
          z: event.z);

      accData.add(measuredData);
    }));
  }

  List<MeasuredDataObject> stopDataStream() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      watch.stop();
    }
    _streamSubscriptions.clear();
    getCsv();
    return accData;
  }

  getCsv() async {
    List<List<dynamic>> rows = List<List<dynamic>>();

    for (int i = 1; i < accData.length; i++) {
      List<dynamic> row = List();
      if (i == 1) {
        row.add('time');
        row.add('x');
        row.add('y');
        row.add('z');
        rows.add(row);
      }
      row.add(accData[i].time);
      row.add(accData[i].x);
      row.add(accData[i].y);
      row.add(accData[i].z);
      rows.add(row);
    }
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      PermissionStatus askForPermission = await Permission.storage.request();
    } else if (await Permission.storage.isRestricted) {
      print('No Permission for storage was granted');
    } else if (await Permission.storage.request().isGranted) {
      String csv = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final pathOfTheFileToWrite = directory.path + "/sensordaten.csv";
      File file = await File(pathOfTheFileToWrite);
      file.writeAsString(csv);
      print('Wrote csv file to $pathOfTheFileToWrite');
      csvPath = pathOfTheFileToWrite;
    }
  }
}

class MeasuredDataObject {
  double time, x, y, z;

  MeasuredDataObject({this.time, this.x, this.y, this.z});
}
