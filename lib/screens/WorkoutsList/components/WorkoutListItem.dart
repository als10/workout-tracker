import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'ExerciseListItem.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  WorkoutListItem({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.name == '' ? workout.dateTime : workout.name,
            style: Theme.of(context).textTheme.headline5
          ),
          Column(
            children: (workout.logs).map((Log log) {
              return ExerciseListItem(
                log: log,
              );
            }).toList()
          ),
        ],
      )
    );
  }
}
