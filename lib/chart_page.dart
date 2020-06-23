import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'switch_creator.dart';

class ChartLayout {
  double maximumX = 0;
  double minimumX = 0;
  double maximumY = 0;
  double minimumY = 0;
  List<FlSpot> accelerometerData = [];

  void MaxMinXandY() {
    for (var i = 0; i < accelerometerData.length; i++) {
      if (accelerometerData[i].x > maximumX) {
        maximumX = accelerometerData[i].x;
      }
      if (accelerometerData[i].x < minimumX) {
        minimumX = accelerometerData[i].x;
      }
    }
    for (var i = 0; i < accelerometerData.length; i++) {
      if (accelerometerData[i].y > maximumY) {
        maximumY = accelerometerData[i].y;
      }
      if (accelerometerData[i].y < minimumY) {
        minimumY = accelerometerData[i].y;
      }
    }
  }
}

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  ///Needed for general functionality of Chart Plugin
  bool showAvg = false;
  List<Color> lineColor = [
    Colors.blue,
  ];

  ///Special variables for Chart Plugin
  DataConverter dataConverter = DataConverter();
  ChartLayout xAccelerometerChart = ChartLayout();
  ChartLayout yAccelerometerChart = ChartLayout();
  ChartLayout zAccelerometerChart = ChartLayout();

  @override
  void initState() {
    super.initState();

    ///Convert measured data into data, which the fl chart plugin can understand
    ///and use for building the line chart. It extracts (currently) the time
    ///and x Axis data from the whole measured dataset "sensordata". time is
    ///represented on the xAxis, whereas accelerometer data is on the yAxis.
    xAccelerometerChart.accelerometerData =
        dataConverter.convertToTimeAndXAcc();
    yAccelerometerChart.accelerometerData =
        dataConverter.convertToTimeAndYAcc();
    zAccelerometerChart.accelerometerData =
        dataConverter.convertToTimeAndZAcc();

    ///Find min and max from x and y axis from chartData for later use
    ///of adjusting the line chart to these values.
    xAccelerometerChart.MaxMinXandY();
    yAccelerometerChart.MaxMinXandY();
    zAccelerometerChart.MaxMinXandY();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Accelerometer Data Chart',
                style: TextStyle(fontSize: 26),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'x-Accelerometer Data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: Container(
                      height: 200,
                      child: LineChart(
                        mainData(xAccelerometerChart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'y-Accelerometer Data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: Container(
                      height: 200,
                      child: LineChart(
                        mainData(yAccelerometerChart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'z-Accelerometer Data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: Container(
                      height: 200,
                      child: LineChart(
                        mainData(zAccelerometerChart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData(ChartLayout data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.w500,
              fontSize: 16),
          getTitles: (value) {
            if (value.toInt() == data.minimumX.toInt()) {
              return data.minimumX.toInt().toString();
            }

            if (value.toInt() == data.maximumX.toInt()) {
              return data.maximumX.toInt().toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt() == data.minimumY.toInt()) {
              return data.minimumY.toInt().toString();
            }

            if (value.toInt() == data.maximumY.toInt()) {
              return data.maximumY.toInt().toString();
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      axisTitleData: FlAxisTitleData(
        leftTitle:
            AxisTitle(showTitle: true, titleText: 'Accelerometer', margin: 4),
        bottomTitle: AxisTitle(
            showTitle: true,
            margin: 0,
            titleText: 'Zeit',
            textStyle: TextStyle(color: Colors.black, fontSize: 14),
            textAlign: TextAlign.right),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 20,
      minY: -15,
      maxY: 15,
      lineBarsData: [
        LineChartBarData(
          colors: lineColor,
          spots: data.accelerometerData,
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
