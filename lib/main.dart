import 'package:accel_data/accel_data.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Accelerometer Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Estimator _estimator = Estimator();
  int _startTime;
  bool _inMotion = false;

  @override
  void initState() {
    super.initState();
    print("Initializing state");
    _reset();
    userAccelerometerEvents.listen((event) {
      setState(() {
        print("listening! $event");
        if (_inMotion) {
          double timeStamp = (DateTime.now().millisecondsSinceEpoch - _startTime) / 1000.0;
          _estimator.add(TimeStamped3D(Value3D(event.x, event.y, event.z), timeStamp));
        }
      });
    });
  }

  void _reset() {
    _estimator.reset();
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Position: ${_estimator.position.uiString()}'),
            Text('Velocity: ${_estimator.velocity.uiString()}'),
            Text('Accelerometer: ${_estimator.acceleration.uiString()}'),
            Text('Readings: ${_estimator.numReadings}'),
            // Put a button here to start/stop recording motion
            RaisedButton(child: Text(_inMotion ? "Stop" : "Start"), onPressed: () {setState(() {
              _inMotion = !_inMotion;
              if (_inMotion) {_reset();}
            });},),
          ],
        ),
      )
    );
  }
}
