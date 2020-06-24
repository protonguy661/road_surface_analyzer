import 'package:fl_chart/fl_chart.dart';
import 'sensor_data.dart';

class DataConverter {
  static SensorData sensorData = SensorData();
  static List<FlSpot> chartDataX = [];
  static List<FlSpot> chartDataY = [];
  static List<FlSpot> chartDataZ = [];

  List<FlSpot> convertToTimeAndXAcc() {
    for (int i = 0; i < SensorData.userAccelerometerValues.length; i++) {
      chartDataX.add(
        FlSpot(
          SensorData.userAccelerometerValues[i].time,
          SensorData.userAccelerometerValues[i].x,
        ),
      );
    }
    return chartDataX;
  }

  List<FlSpot> convertToTimeAndYAcc() {
    for (int i = 0; i < SensorData.userAccelerometerValues.length; i++) {
      chartDataY.add(
        FlSpot(
          SensorData.userAccelerometerValues[i].time,
          SensorData.userAccelerometerValues[i].y,
        ),
      );
    }
    return chartDataY;
  }

  List<FlSpot> convertToTimeAndZAcc() {
    for (int i = 0; i < SensorData.userAccelerometerValues.length; i++) {
      chartDataZ.add(
        FlSpot(
          SensorData.userAccelerometerValues[i].time,
          SensorData.userAccelerometerValues[i].z,
        ),
      );
    }
    return chartDataZ;
  }
}
