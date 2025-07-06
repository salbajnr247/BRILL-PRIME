import 'package:flutter/cupertino.dart';

class OpeningHoursModel {
  final String dayOfTheWeek;
  final String openingHour;
  final String openingTime;
  final String closingHour;
  final String closingTime;
  final TextEditingController openingHourController;
  final TextEditingController closingHourController;

  OpeningHoursModel(
      {required this.closingHour,
      required this.closingTime,
      required this.dayOfTheWeek,
      required this.openingHour,
      required this.openingTime,
      required this.openingHourController,
      required this.closingHourController});
}
