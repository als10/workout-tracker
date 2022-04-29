import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/AddExerciseForm/AddExerciseForm.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Function updateExercise;

  ExerciseListItem({required this.exercise, required this.updateExercise});

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
    List<Widget> _createProgressionsList(List<Progression> progressions) {
      progressions.sort((a, b) => a.rank - b.rank);
      return progressions.map((Progression p) =>
          GestureDetector(
            onTap: () => Navigator.of(context).pop(exercise),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${p.rank + 1}'),
                  ),
                  SizedBox(width: 16),
                  Text(p.name),
                ],
              ),
            ),
          )).toList();
    }

    return ExpansionTile(
      title: Text(
        exercise.name,
        style: TextStyle(fontSize: 20),
      ),
      children: [
        ..._createProgressionsList(exercise.progressions),
        SizedBox(height: 16),
      ],
    );
  }
}
