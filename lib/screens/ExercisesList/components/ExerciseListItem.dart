import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/AddExerciseForm/AddExerciseForm.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Function updateExercise;

  ExerciseListItem({required this.exercise, required this.updateExercise});

  List<Widget> _createProgressionsList(List<Progression> progressions) {
    List<String> progressionNames =
        progressions.map((Progression p) => p.name).toList();
    progressionNames.sort((a, b) => a.compareTo(b));
    return progressionNames.map((String pname) => Text(pname)).toList();
  }

  void _navigateToUpdateExercise(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddExerciseForm(
        upsert: updateExercise,
        exercise: exercise,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(exercise.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _createProgressionsList(exercise.progressions),
          ),
          onTap: () => Navigator.of(context).pop(exercise),
        ),
        Divider(),
      ],
    );
  }
}
