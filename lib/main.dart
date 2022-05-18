import 'dart:isolate';

import 'package:cp_helper/api_service.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

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
  late Future<List<Contests>> users;

  @override
  void initState() {
    super.initState();
    users = getContestList();
  }

  @override
  Widget build(BuildContext context) {
    bool _lights = false;
    const int helloAlarmID = 0;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('CP Calendar'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Contests>>(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return SwitchListTile(
                        title: Text(snapshot.data![index].name),
                        isThreeLine: true,
                        value: _lights,
                        onChanged: (bool value) {
                          setState(() {
                            _lights = value;
                          });
                          print("Here");
                          AndroidAlarmManager.oneShot(
                              const Duration(seconds: 1),
                              helloAlarmID,
                              printHello);
                        },
                        // leading: Text(snapshot.data![index].duration),
                        subtitle:
                            Text(snapshot.data![index].startTime.toString()),
                        // trailing: Text(snapshot.data![index].site),
                        // onTap: () {
                        //   FlutterAlarmClock.createAlarm(23, 59);
                        // }
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
