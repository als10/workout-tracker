import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/ExercisesList/ExercisesList.dart';

class ExerciseInput extends StatelessWidget {
  Exercise exercise;
  final Function setExercise;
  ExerciseInput({Exercise? exercise, required this.setExercise}) : this.exercise = exercise ?? Exercise.empty();

  Future<void> _navigateToChooseExercise(BuildContext context) async {
    exercise = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExercisesList())
    );
    setExercise(exercise);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToChooseExercise(context),
      child: Text(exercise.name)
    );
  }
}
