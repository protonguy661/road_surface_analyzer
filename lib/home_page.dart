import 'package:flutter/material.dart';
import 'package:sensordatenapp/providers.dart';
import 'sensor_data.dart';
import 'data_converter.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SensorData sensorData = SensorData();
  DataConverter switchCreator = DataConverter();
  List<MeasuredDataObject> tempAccData = [];

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
                        ? MainButton(
                            title: 'Start Measurement',
                            color: Colors.white,
                            textColor: Colors.black,
                            function: () {
                              sensorData.startDataStream();
                              _.switchView('startMeasuring');
                              _.switchView('stopMeasuring');
                            },
                          )
                        : MainButton(
                            title: 'Start Measurement',
                            color: Colors.grey,
                            textColor: Colors.white,
                            function: () {},
                          );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<ViewNotifier>(
                  builder: (context, _, child) {
                    return _.show['stopMeasuring']
                        ? MainButton(
                            title: 'Stop Measurement',
                            color: Colors.white,
                            textColor: Colors.black,
                            function: () {
                              tempAccData = sensorData.stopDataStream();
                              _.switchView('stopMeasuring');
                              _.switchView('buildChart');
                            },
                          )
                        : MainButton(
                            title: 'Stop Measurement',
                            color: Colors.grey,
                            textColor: Colors.white,
                            function: () {},
                          );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<ViewNotifier>(
                  builder: (context, _, child) {
                    return _.show['buildChart']
                        ? MainButton(
                            title: 'Build Chart',
                            color: Color(0xFF655BB5),
                            textColor: Colors.white,
                            function: () {
                              Navigator.pushNamed(context, '/graph',
                                  arguments: tempAccData);
                              _.switchView('buildChart');
                              _.switchView('startMeasuring');
                            },
                          )
                        : MainButton(
                            title: 'Build Chart',
                            color: Colors.grey,
                            textColor: Colors.white,
                            function: () {},
                          );
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
  MainButton({this.title, this.function, this.color, this.textColor});
  String title;
  Function function;
  Color color;
  Color textColor;
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
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        onPressed: function,
      ),
    );
  }
}
