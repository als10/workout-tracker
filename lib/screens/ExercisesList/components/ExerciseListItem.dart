import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/AddExerciseForm/AddExerciseForm.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Function updateExercise;
  final Function deleteExercise;

  ExerciseListItem({required this.exercise, required this.updateExercise, required this.deleteExercise});

  void _navigateToUpdateExercise(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddExerciseForm(
        upsert: updateExercise,
        exercise: exercise,
      ),
    ));
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to delete this exercise?\nWARNING: All workouts using this exercise will also be deleted.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    );
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
                    radius: 12,
                  ),
                  SizedBox(width: 16),
                  Text(p.name),
                ],
              ),
            ),
          )).toList();
    }

    return ExpansionTile(
      title: GestureDetector(
        onTap: () => Navigator.of(context).pop(exercise),
        child: Text(exercise.name),
      ),
      children: [
        ..._createProgressionsList(exercise.progressions),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => _navigateToUpdateExercise(context),
              icon: Icon(Icons.edit),
              label: Text('Edit')
            ),
            TextButton.icon(
                onPressed: () async {
                  if ((await _confirmDelete(context)) ?? false) deleteExercise(exercise);
                },
                icon: Icon(Icons.delete),
                label: Text('Delete')
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
