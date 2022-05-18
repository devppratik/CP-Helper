import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AlarmClock {
  static const MethodChannel _channel = MethodChannel('alarm_clock');

  /// Create an alarm.
  ///
  /// 'hour' specifies alarm hour
  /// 'minutes' specifies alarm minutes
  /// 'title' specifies alarm title - optional
  /// 'skipUi' specifies whether clock app should open or not - optional
  static void createAlarm(int hour, int minutes,
      {String title = "", bool skipUi = true}) {
    try {
      if (Platform.isAndroid) {
        _channel.invokeMethod('createAlarm', <String, dynamic>{
          'hour': hour,
          'minutes': minutes,
          'title': title,
          'skipUi': skipUi,
        });
      } else {
        throw UnimplementedError;
      }
    } on PlatformException {
      debugPrint("Error creating an alarm.");
    }
  }
}
