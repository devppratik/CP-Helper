import 'dart:isolate';

import 'package:cp_helper/alarm_clock.dart';
import 'package:cp_helper/api_service.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Contests>> contests;
  List<bool> _lights = [];

  @override
  void initState() {
    super.initState();
    contests = getContestList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('CP Calendar'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Contests>>(
            future: contests,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      _lights.add(false);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final startTime =
                          DateTime.parse(snapshot.data![index].startTime);
                      final aDate = DateTime(
                          startTime.year, startTime.month, startTime.day);
                      // // TODO : CHECK TIME ALSO
                      // // If Time is greater than the contest dont create a alarm
                      if (aDate == today) {
                        FlutterAlarmClock.createAlarm(
                            startTime.hour + 5, startTime.minute + 25,
                            title: snapshot.data![index].name);
                      }
                      return ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(
                            "${snapshot.data![index].startTimeFormatted} - ${snapshot.data![index].endTimeFormatted}"),
                        leading: Text(snapshot.data![index].site),
                        isThreeLine: true,
                      );
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    ));
  }
}

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
}

bool isCurrentDateInRange(DateTime startDate) {
  final currentDate = DateTime.now();
  return currentDate.isBefore(startDate);
}
