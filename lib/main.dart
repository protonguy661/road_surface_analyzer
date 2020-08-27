import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensordatenapp/result_page.dart';
import 'chart_page.dart';
import 'home_page.dart';
import 'package:flutter/services.dart' as serv;

Future main() async {
  ///Set forced Portrait Mode for App
  WidgetsFlutterBinding.ensureInitialized();
  await serv.SystemChrome.setPreferredOrientations([
    serv.DeviceOrientation.portraitUp,
  ]);

  ///Start the App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getPermissions();
    _signInAnonymously();
    return MaterialApp(
      title: 'Road Surface Analyzer',
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

  ///============Check permission status =======================================
  ///The App uses the location of the device to get the GPS coordinates. The
  ///coordinates are needed for displaying the driven route on the result page.
  ///Moreover a storage permission is needed for caching the accelerometer data
  ///on the device before it gets uploaded to the Firebase Cloud.

  void _getPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print('Permission for location: ${statuses[Permission.location]}');
    print('Permission for storage: ${statuses[Permission.storage]}');
  }

  ///===========================================================================

  ///===============Anonymous Sign in===========================================
  ///A Sign in is needed for using the Firebase Cloud. Only with this anonymous
  ///sign in the user is able to upload the accelerometer data as a .csv file
  ///to Firebase, which then will be processed by the Python Cloud Function for
  ///surface type prediction.

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Successfully signed in anonymous user.');
    } catch (e) {
      print(e);
    }
  }

  ///===========================================================================
}
