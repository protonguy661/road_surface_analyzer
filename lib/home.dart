import 'package:flutter/material.dart';
import 'sensor_data.dart';
import 'switch_creator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SensorData sensorData = SensorData();
  DataConverter switchCreator = DataConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                child: Text('Messung starten'),
                onPressed: () {
                  sensorData.startDataStream();
                  //startStream();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                child: Text('Messung stoppen'),
                onPressed: () {
                  sensorData.stopDataStream();
                  //stopStream();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                child: Text('Chart bauen'),
                onPressed: () {
                  Navigator.pushNamed(context, '/graph');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
