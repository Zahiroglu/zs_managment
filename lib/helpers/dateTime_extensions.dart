import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime setTimeOfDay(TimeOfDay time) {
    return DateTime(this.year, this.month, this.day, time.hour, time.minute);
  }

  DateTime setTime(
      {int hours = 0,
        int minutes = 0,
        int seconds = 0,
        int milliSeconds = 0,
        int microSeconds = 0}) {
    return DateTime(this.year, this.month, this.day, hours, minutes, seconds,
        milliSeconds, microSeconds);
  }

  DateTime clearTime() {
    return DateTime(this.year, this.month, this.day, 0, 0, 0, 0, 0);
  }

///..... add more methods/properties for your convenience
}