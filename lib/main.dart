import 'package:flutter/material.dart';
import 'chart_page.dart';
import 'home.dart';

//Messung von Zeit und Achsenveränderungen funktioniert.
//Start, Stop der Messung funktioniert.
//Messdaten können als Double Liste auf der Konsole ausgegeben werden.
//TODO: Graphen erstellen aus den Messdaten
//TODO: Double Liste als csv exportieren können
//TODO: Zurücksetzen knopf einbauen um alle Listen und Daten für neue Messungen löschen zu können, außer die CSVs

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Roughness Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/home': (context) => MyHomePage(),
        '/graph': (context) => LineChartSample2(),
      },
    );
  }
}
