import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensordatenapp/providers.dart';
import 'package:sensordatenapp/screenSizeProperties.dart';
import 'sensor_and_gps.dart';
import 'data_converter.dart';
import 'package:provider/provider.dart';
import 'csv.dart';
import 'package:lottie/lottie.dart';

enum ChangeState {
  no,
  light,
  medium,
  high,
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double coefficient;
  int frequency;
  final myController = TextEditingController();
  SensorData sensorData = SensorData();
  Csv csv = Csv();
  DataConverter switchCreator = DataConverter();
  List<MeasuredDataObject> tempAccData = [];
  ChangeState selectedState;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeProperties().init(context);

    return ChangeNotifierProvider<ViewNotifier>(
      create: (context) => ViewNotifier(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Consumer<ViewNotifier>(
                      builder: (context, _, child) {
                        return _.show['showLogo']
                            ? Container(
                                height:
                                    ScreenSizeProperties.safeBlockHorizontal *
                                        50,
                                width:
                                    ScreenSizeProperties.safeBlockHorizontal *
                                        50,
                                child: Image.asset('assets/images/bicycle.png'),
                              )
                            : Container();
                      },
                    ),
                    Consumer<ViewNotifier>(
                      builder: (context, _, child) {
                        return _.show['showLogo']
                            ? Container(
                                child: Text(
                                  'Road Surface Analyzer',
                                  style: TextStyle(fontSize: 26),
                                ),
                              )
                            : Container();
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Consumer<ViewNotifier>(
                      builder: (context, _, child) {
                        return _.show['startMeasuring']
                            ? MainButton(
                                title: 'Start Cycling',
                                color: Colors.white,
                                textColor: Colors.black,
                                function: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Information"),
                                        content: Text(
                                            "Please record at least 30 seconds of cycling. Otherwise the "
                                            "road surface prediction cannot be executed. Recording will start after pressing on OK."),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              sensorData.startDataStream();
                                              sensorData.trackPosition();
                                              _.switchView('showLogo');
                                              _.switchView('startMeasuring');
                                              _.switchView('stopMeasuring');
                                              _.switchView('showIndicator');
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            : _.show['showIndicator']
                                ? Container(
                                    width: ScreenSizeProperties
                                            .safeBlockHorizontal *
                                        50,
                                    height: ScreenSizeProperties
                                            .safeBlockHorizontal *
                                        50,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Lottie.asset(
                                            'assets/lottie/bicycle.json',
                                          ),
                                          SizedBox(
                                            height: ScreenSizeProperties
                                                    .safeBlockVertical *
                                                2,
                                          ),
                                          Text(
                                              'Recording accelerometer data...'),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Consumer<ViewNotifier>(
                      builder: (context, _, child) {
                        return _.show['stopMeasuring']
                            ? MainButton(
                                title: 'Stop Cycling',
                                color: Colors.white,
                                textColor: Colors.black,
                                function: () {
                                  tempAccData = sensorData.stopDataStream();
                                  _.stopWatch();
                                  _.switchView('stopMeasuring');
                                  _.switchView('buildChart');
                                  _.switchView('showIndicator');
                                },
                              )
                            : Container();
                      },
                    ),
                    Consumer<ViewNotifier>(
                      builder: (context, _, child) {
                        return _.show['buildChart']
                            ? Container(
                                padding: EdgeInsets.all(
                                    ScreenSizeProperties.safeBlockHorizontal *
                                        5),
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
                                width:
                                    ScreenSizeProperties.safeBlockHorizontal *
                                        75,
                                height:
                                    ScreenSizeProperties.safeBlockVertical * 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Choose your suspension type',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: ScreenSizeProperties
                                              .safeBlockVertical *
                                          6,
                                      thickness: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Container(
                                      height: ScreenSizeProperties
                                              .safeBlockVertical *
                                          10,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedState =
                                                      ChangeState.no;
                                                  coefficient = 0.0;
                                                  print(
                                                      'coefficient is $coefficient');
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    ScreenSizeProperties
                                                            .safeBlockHorizontal *
                                                        1),
                                                decoration: BoxDecoration(
                                                  color: selectedState ==
                                                          ChangeState.no
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 3,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'No suspension',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenSizeProperties
                                                    .safeBlockHorizontal *
                                                4,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedState =
                                                      ChangeState.light;
                                                  coefficient = 0.15;
                                                  print(
                                                      'coefficient is $coefficient');
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    ScreenSizeProperties
                                                            .safeBlockHorizontal *
                                                        1),
                                                decoration: BoxDecoration(
                                                  color: selectedState ==
                                                          ChangeState.light
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 3,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Light suspension',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenSizeProperties
                                              .safeBlockVertical *
                                          1.5,
                                    ),
                                    Container(
                                      height: ScreenSizeProperties
                                              .safeBlockVertical *
                                          10,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedState =
                                                      ChangeState.medium;
                                                  coefficient = 0.33;
                                                  print(
                                                      'coefficient is $coefficient');
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    ScreenSizeProperties
                                                            .safeBlockHorizontal *
                                                        1),
                                                decoration: BoxDecoration(
                                                  color: selectedState ==
                                                          ChangeState.medium
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 3,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Medium suspension',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenSizeProperties
                                                    .safeBlockHorizontal *
                                                4,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedState =
                                                      ChangeState.high;
                                                  coefficient = 0.48;
                                                  print(
                                                      'coefficient is $coefficient');
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    ScreenSizeProperties
                                                            .safeBlockHorizontal *
                                                        1),
                                                decoration: BoxDecoration(
                                                  color: selectedState ==
                                                          ChangeState.high
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 3,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'High suspension',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenSizeProperties
                                              .safeBlockVertical *
                                          3,
                                    ),
                                    coefficient != null
                                        ? MainButton(
                                            title: 'Predict Road Surface',
                                            color: Color(0xFF655BB5),
                                            textColor: Colors.white,
                                            function: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Information"),
                                                      content: Text(
                                                          "The App could freeze if you click on 'OK' but you will get redirected to the prediction page a couple of seconds later. Please have patience."),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text("OK"),
                                                          onPressed: () async {
                                                            await csv.createCSV(
                                                                coefficient,
                                                                frequency,
                                                                tempAccData);

                                                            Navigator.pushNamed(
                                                                context,
                                                                '/result');
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                              /*  Navigator.pushNamed(
                                                  context, '/graph',
                                                  arguments: tempAccData);*/
                                            },
                                          )
                                        : Container(),
                                  ],
                                ),
                              )
                            : Container();
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: ScreenSizeProperties.safeBlockVertical * 2),
                  child: Text(
                    'By LGO4QS for Analyse von Sensordaten',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              )
            ],
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
    ScreenSizeProperties().init(context);
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
      height: ScreenSizeProperties.safeBlockVertical * 8,
      width: ScreenSizeProperties.safeBlockHorizontal * 50,
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
