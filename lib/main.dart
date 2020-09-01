import 'package:flutter/material.dart';
import 'package:user_accel_tracker/tracker.dart';
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

const double _accelerometerNoiseThreshold = 0.1;

double filterNoise(double reading) => reading.abs() >= _accelerometerNoiseThreshold
    ? reading
    : 0.0;

class _MyHomePageState extends State<MyHomePage> {
  Estimator _estimator = Estimator();
  int _startTime;

  @override
  void initState() {
    super.initState();
    print("Initializing state");
    _startTime = DateTime.now().millisecondsSinceEpoch;
    userAccelerometerEvents.listen((event) {
      setState(() {
        print("listening! $event");
        double timeStamp = (DateTime.now().millisecondsSinceEpoch - _startTime) / 1000.0;
        _estimator.add(TimeStamped3D(Value3D(filterNoise(event.x), filterNoise(event.y), filterNoise(event.z)), timeStamp));
      });
    });
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
            Text('Readings: ${_estimator.numReadings}')
          ],
        ),
      )
    );
  }
}
