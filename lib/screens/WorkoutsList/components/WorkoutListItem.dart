import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';
import 'LogListItem.dart';
import 'package:intl/intl.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;
  final Function updateWorkout;

  WorkoutListItem({
    required this.workout,
    required this.updateWorkout,
  });

  void _navigateToUpdateWorkout(BuildContext context) {
    Navigator.pushNamed(
      context,
      AddWorkoutForm.routeName,
      arguments: ScreenArguments(updateWorkout, workout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title:
            Text(DateFormat('h:mm a - MMM d, yyyy').format(workout.dateTime)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                workout.logs.map((Log log) => LogListItem(log: log)).toList(),
          ),
          onTap: () => _navigateToUpdateWorkout(context),
        ),
        Divider(),
      ],
    );
  }
}
