import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensordatenapp/result_page.dart';
import 'chart_page.dart';
import 'home_page.dart';
import 'package:flutter/services.dart' as serv;

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
    _getPermissions();
    _signInAnonymously();
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

  void _getPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print('Permission for location: ${statuses[Permission.location]}');
    print('Permission for storage: ${statuses[Permission.storage]}');
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Successfully signed in anonymous user.');
    } catch (e) {
      print(e);
    }
  }
}
