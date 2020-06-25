import 'package:fl_chart/fl_chart.dart';
import 'sensor_data.dart';

class DataConverter {
  SensorData sensorData = SensorData();
  List<FlSpot> chartDataX = [];
  List<FlSpot> chartDataY = [];
  List<FlSpot> chartDataZ = [];

  List<FlSpot> FLSpotConversion_TX(List<MeasuredDataObject> accData) {
    for (int i = 0; i < accData.length; i++) {
      chartDataX.add(
        FlSpot(
          accData[i].time,
          accData[i].x,
        ),
      );
    }
    return chartDataX;
  }

  List<FlSpot> FLSpotConversion_TY(List<MeasuredDataObject> accData) {
    for (int i = 0; i < accData.length; i++) {
      chartDataY.add(
        FlSpot(
          accData[i].time,
          accData[i].y,
        ),
      );
    }
    return chartDataY;
  }

  List<FlSpot> FLSpotConversion_TZ(List<MeasuredDataObject> accData) {
    for (int i = 0; i < accData.length; i++) {
      chartDataZ.add(
        FlSpot(
          accData[i].time,
          accData[i].z,
        ),
      );
    }
    return chartDataZ;
  }
}
