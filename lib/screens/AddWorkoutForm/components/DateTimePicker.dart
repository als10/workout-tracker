import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimePicker {
  static Future<DateTime?> selectDate(
      BuildContext context, DateTime initialDate) async {
    return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
  }

  static Future<TimeOfDay?> selectTime(
      BuildContext context, TimeOfDay initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
  }
}
