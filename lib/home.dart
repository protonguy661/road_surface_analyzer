import 'package:flutter/material.dart';
import 'package:sensordatenapp/chart_page.dart';
import 'package:sensordatenapp/providers.dart';
import 'sensor_data.dart';
import 'switch_creator.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SensorData sensorData = SensorData();
  DataConverter switchCreator = DataConverter();



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewNotifier>(
      create: (context) => ViewNotifier(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Text(
                    'Road Roughness Checker',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Consumer<ViewNotifier>(
                  builder: (context, _, child) {
                    return _.show['startMeasuring']
                        ?
                      MainButton(title: 'Messung starten',
                        color: Colors.white,
                      function: () {
                        SensorData.userAccelerometerValues = [];
                        DataConverter.sensorData = SensorData();
                        DataConverter.chartDataX = [];
                        DataConverter.chartDataY = [];
                        DataConverter.chartDataZ = [];

                        sensorData.startDataStream();
                        _.switchView('startMeasuring');
                        _.switchView('stopMeasuring');
                      },)
                     : MainButton(title: 'Messung starten',
                      color: Colors.grey,
                    function: () {},);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<ViewNotifier>(
                  builder: (context, _, child) {
                    return _.show['stopMeasuring']
                        ?
                    MainButton(title: 'Messung stoppen',
                      color: Colors.white,
                      function: () {
                        sensorData.stopDataStream();
                        _.switchView('stopMeasuring');
                        _.switchView('buildChart');
                      },)
                        : MainButton(title: 'Messung stoppen',
                      color: Colors.grey,
                      function: () {},);
                  },
                ),

                SizedBox(
                  height: 20,
                ),
                Consumer<ViewNotifier>(
                  builder: (context, _, child) {
                    return _.show['buildChart']
                        ?
                    MainButton(title: 'Chart bauen',
                      color: Colors.white,
                      function: () {
                        Navigator.pushNamed(context, '/graph');
                        _.switchView('buildChart');
                        _.switchView('startMeasuring');
                      },)
                        : MainButton(title: 'Chart bauen',
                      color: Colors.grey,
                      function: () {},);
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class MainButton extends StatelessWidget {
  MainButton({this.title, this.function, this.color});
  String title;
  Function function;
  Color color;
  SensorData sensorData = SensorData();
  DataConverter switchCreator = DataConverter();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 6,
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 60,
      width: 200,
      child: FlatButton(
        child: Text(title),
        onPressed: function,
      ),
    );
  }
}

