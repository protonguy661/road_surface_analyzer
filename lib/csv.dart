import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensordatenapp/sensor_and_gps.dart';
import 'dart:io';

class Csv {
  ///==============Building .csv file===========================================
  ///The .csv file will be created here and filled with the accelerometer data,
  ///the devices' frequency of the accelerometer sensor and the selected
  ///suspension coefficient. After creating the file, it will be saved on the
  ///device.

  createCSV(double coef, int freq, List<MeasuredDataObject> accData) async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    int frequency = 0;

    for (int i = 0; accData[i].time < 1; i++) {
      frequency = frequency + 1;
    }
    print('Hz of Device: $frequency');

    for (int i = 0; i < accData.length; i++) {
      List<dynamic> row = List();
      if (i == 0) {
        row.add('time');
        row.add('x');
        row.add('y');
        row.add('z');
        row.add(coef);
        row.add(frequency);
        rows.add(row);
      } else {
        row.add(accData[i].time);
        row.add(accData[i].x);
        row.add(accData[i].y);
        row.add(accData[i].z);
        rows.add(row);
      }
    }
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      print('Permission for storage is not set yet.');
    } else if (await Permission.storage.isRestricted) {
      print('No Permission for storage was granted');
    } else if (await Permission.storage.isGranted) {
      String csv = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final pathOfTheFileToWrite = directory.path + "/sensordaten.csv";
      dataFile = null;
      dataFile = File(pathOfTheFileToWrite);
      await dataFile.writeAsString(csv);
      print('Wrote csv file to $pathOfTheFileToWrite');
      csvPath = '';
      csvPath = pathOfTheFileToWrite;
    }
  }

  ///===========================================================================
}
