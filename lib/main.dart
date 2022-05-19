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
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.alarm,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FlutterAlarmClock.showAlarms();
                  },
                )
              ],
            ),
            body: Center(
              child: FutureBuilder<List<Contests>>(
                  future: contests,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: snapshot.data!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              FlutterAlarmClock.createAlarm(20, 00,
                                  title: "Daily LeetCode Practice");
                              return const ListTile(
                                title: Text(
                                  "Daily Leetocde Question Practice",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                subtitle: Text(
                                  "Daily 8:00 PM",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/leetcode.png"),
                                  backgroundColor: Colors.white,
                                ),
                                // isThreeLine: true,
                              );
                            }
                            _lights.add(false);
                            final now = DateTime.now();
                            final today =
                                DateTime(now.year, now.month, now.day);
                            final startTime = DateTime.parse(
                                snapshot.data![index - 1].startTime);
                            final aDate = DateTime(
                                startTime.year, startTime.month, startTime.day);
                            // TODO : CHECK TIME ALSO
                            // If Time is greater than the contest dont create a alarm
                            if (aDate == today) {
                              FlutterAlarmClock.createAlarm(
                                  startTime.hour + 5, startTime.minute + 25,
                                  title: snapshot.data![index - 1].name);
                            }
                            return ListTile(
                              title: Text(
                                snapshot.data![index - 1].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 17),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index - 1].startTimeFormatted} - ${snapshot.data![index - 1].endTimeFormatted}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                    "images/${snapshot.data![index - 1].image}.png"),
                                backgroundColor: Colors.white,
                              ),
                              // isThreeLine: true,
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            )));
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
