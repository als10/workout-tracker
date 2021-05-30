import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'LogListItem.dart';
import 'package:intl/intl.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  WorkoutListItem({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: workout.dateTime != null
            ? Text(DateFormat('h:mm a - MMM d, yyyy').format(workout.dateTime!))
            : Text(''),
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
