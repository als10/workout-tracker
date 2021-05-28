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
    String hour = timeList[0];
    String minute = timeList[1];
    
    return '$hour:$minute - $day $month, $year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(workout.dateTime),
            style: Theme.of(context).textTheme.headline5
          ),
          Column(
            children: workout.logs.map((Log log) {
              return LogListItem(
                log: log,
              );
            }).toList()
          ),
        ],
      )
    );
  }
}
