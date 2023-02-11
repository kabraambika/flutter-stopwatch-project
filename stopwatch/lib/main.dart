import 'package:flutter/material.dart';
import 'dart:async';

/// MAIN: Running our stopwatch app here
void main() {
  runApp(const MyApp());
}

/// Function converting the milliseconds from a running stopwatch and converting it to minutes, seconds, and milli display values.
String calculateElapsed(total) {
  if (total == 0) {
    return "00:00.000";
  } else {
    int minutes = total ~/ 60000;
    int seconds = (total - (minutes * 60000)) ~/ 1000;
    int milli = total - (minutes * 60000) - (seconds * 1000);
    return "${"$minutes".padLeft(2, "0")}:${"$seconds".padLeft(2, "0")}.${"$milli".padLeft(3, "0")}";
  }
}

/// MY_APP: A widget that sets up the barebones app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Stopwatch'),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// MY_HOME_PAGE: A widget that creates a homepage for the app
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// MY_HOME_PAGE_STATE: A widget that does the hard work of building out the details of MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  final Stopwatch _stopWatch = Stopwatch();
  String _elapsed = "00:00.000";

  int total = 0;
  int minutes = 0;
  int seconds = 0;
  int milli = 0;
  Timer? timer;
  static const duration = Duration(microseconds: 69);

  ///Update the clock with help of calculateElapsed function
  void _updateClock() {
    setState(() {
      total = _stopWatch.elapsedMilliseconds;
      _elapsed = calculateElapsed(total);
    });
  }

  ///To make sure the later tests work correctly
  ///This is because the tester does not like open timers.
  ///Adding this code ensures that the timer will be closed when the app no longer needs it.
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    timer ??= Timer.periodic(duration, (Timer t) {
      _updateClock();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          semanticsLabel: widget.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _elapsed,
              style: const TextStyle(fontSize: 50, fontFamily: 'Courier'),
              semanticsLabel: semanticTimeConversion(_elapsed),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton.icon(
                  label: const Text(
                    'Stop',
                    style: TextStyle(fontSize: 20),
                  ),
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    if (_stopWatch.isRunning) {
                      _stopWatch.stop();
                    } else {
                      _stopWatch.reset();
                    }
                  },
                ),
                OutlinedButton.icon(
                  label: const Text(
                    'Play',
                    style: TextStyle(fontSize: 20),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    _stopWatch.start();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///Function that converts a time string like "00:00.000" to its semantic version i.e. "0 minutes 0 seconds 0 milliseconds"
String semanticTimeConversion(String time_string) {
  if (time_string == "00:00.000") {
    return "0 minutes 0 seconds 0 milliseconds";
  } else {
    final firstList = time_string.split(":");
    final secList = firstList[1].split(".");
    return '${int.parse(firstList[0])} minutes ${int.parse(secList[0])} seconds ${int.parse(secList[1])} milliseconds';
  }
}
