import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Contests {
  String name;
  String site;
  String startTime;
  String endTime;
  String duration;

  Contests({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.site,
    required this.duration,
  });

  factory Contests.fromJson(Map<String, dynamic> json) => Contests(
      name: json["name"],
      site: json["site"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      duration: json["duration"]);
}

Future<List<Contests>> getContestList() async {
  final response = await http.get(
    Uri.parse('https://kontests.net/api/v1/all'),
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Contests> contests = [];
    for (var item in jsonResponse) {
      Contests contest = Contests(
          name: item['name'],
          site: item["site"],
          startTime: item["start_time"],
          endTime: item["end_time"],
          duration: item["duration"]);
      contests.add(contest);
    }
    const preferedSites = ["CodeForces", "CodeChef", "LeetCode", "AtCoder"];
    contests.retainWhere((element) => preferedSites.contains(element.site));

    return contests;
  } else {
    throw Exception('Failed to load post');
  }
}
