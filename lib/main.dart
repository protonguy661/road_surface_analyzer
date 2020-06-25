import 'package:flutter/material.dart';
import 'package:sensordatenapp/result_page.dart';
import 'chart_page.dart';
import 'home_page.dart';
import 'package:flutter/services.dart' as serv;

//TODO: Double Liste als csv exportieren können
//TODO: Zurücksetzen knopf einbauen um alle Listen und Daten für neue Messungen löschen zu können, außer die CSVs

Future main() async {
  ///Set Portrait Mode for App
  WidgetsFlutterBinding.ensureInitialized();
  await serv.SystemChrome.setPreferredOrientations([
    serv.DeviceOrientation.portraitUp,
  ]);

  ///Run App
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
        '/graph': (context) => ChartPage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}
