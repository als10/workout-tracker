import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'LogListItem.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  WorkoutListItem({
    required this.workout,
  });

  String formatDate(String dateTime) {
    if (dateTime == '') return '';
    List<String> dateTimeList = dateTime.split(' ');
    
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    List<String> dateList = dateTimeList[0].split('-');
    String year = dateList[0];
    String month = months[int.parse(dateList[1]) - 1];
    String day = dateList[2];
    
    List<String> timeList = dateTimeList[1].split(':');
    int hour = int.parse(timeList[0]);
    String minute = timeList[1];

    String time;
    if (hour > 12) {
      time = '${hour - 12}:$minute PM';
    } else if (hour == 12) {
      time = '12:$minute PM';
    } else if (hour == 0) {
      time = '12:$minute AM';
    } else {
      time = '$hour:$minute AM';
    }
    
    return '$time - $day $month, $year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(formatDate(workout.dateTime)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              workout.logs.map((Log log) => LogListItem(log: log)).toList(),
          ),
        ),
        Divider(),
      ],
    );
  }
}
