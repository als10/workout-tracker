import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';

import 'SetListItem.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;
  final Function updateWorkout;

  WorkoutListItem({
    required this.workout,
    required this.updateWorkout,
  });

  void _navigateToUpdateWorkout(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddWorkoutForm(
        upsert: updateWorkout,
        workout: workout,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        DateFormat('h:mm a').format(workout.dateTime),
        style: TextStyle(fontSize: 20),
      ),
      children: workout.sets
          .map((ExerciseSet set) =>
            SetListItem(
              set: set,
              navigate: () => _navigateToUpdateWorkout(context)
            )
          ).toList(),
    );

    //   Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.all(4),
    //       child: ListTile(
    //         title: ,
    //         subtitle: ,
    //         onTap: () => _navigateToUpdateWorkout(context),
    //       ),
    //     ),
    //     Divider(),
    //   ],
    // );
  }
}
