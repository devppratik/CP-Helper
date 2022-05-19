import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Contests {
  String name;
  String site;
  String image;
  String startTimeFormatted;
  String endTimeFormatted;
  String startTime;
  String endTime;
  String duration;

  Contests({
    required this.name,
    required this.image,
    required this.startTime,
    required this.endTime,
    required this.startTimeFormatted,
    required this.endTimeFormatted,
    required this.site,
    required this.duration,
  });

  factory Contests.fromJson(Map<String, dynamic> json) => Contests(
      name: json["name"],
      site: json["site"],
      image: json["image"],
      startTimeFormatted: json["start_time"],
      endTimeFormatted: json["end_time"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      duration: json["duration"]);
}

Future<List<Contests>> getContestList() async {
  // TODO : Change API To Clist https://clist.by/api/v2/contest/
  final response = await http.get(
    Uri.parse('https://kontests.net/api/v1/all'),
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Contests> contests = [];
    for (var item in jsonResponse) {
      // Date Conversion Logic
      String newStartTime = "", newEndTime = "";
      if (item["start_time"].toString().endsWith("UTC")) {
        var sTime = item["start_time"];
        var eTime = item["end_time"];
        newStartTime = sTime.toString().substring(0, sTime.length - 4);
        newEndTime = eTime.toString().substring(0, eTime.length - 4);
      } else {
        newStartTime = item["start_time"];
        newEndTime = item["end_time"];
      }

      var formattedStartTime = DateFormat("E dd-MM hh:mm aa")
          .format(DateTime.parse(newStartTime).toLocal());
      var formattedEndTime = DateFormat("E dd-MM hh:mm aa")
          .format(DateTime.parse(newEndTime).toLocal());
      var siteImage = item["site"].toString().toLowerCase();
      Contests contest = Contests(
          name: item['name'],
          site: item["site"],
          image: siteImage,
          startTimeFormatted: formattedStartTime,
          endTimeFormatted: formattedEndTime,
          startTime: newStartTime,
          endTime: newEndTime,
          duration: item["duration"]);

      contests.add(contest);
    }
    const preferedSites = ["CodeForces", "CodeChef", "LeetCode", "AtCoder"];
    contests.retainWhere((element) => preferedSites.contains(element.site));
    contests.sort(((a, b) => a.startTime.compareTo(b.startTime)));

    return contests;
  } else {
    throw Exception('Failed to load post');
  }
}
