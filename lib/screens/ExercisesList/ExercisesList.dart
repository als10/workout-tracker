import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/AddExerciseForm/AddExerciseForm.dart';
import 'package:workout_tracker/screens/ExercisesList/components/ExerciseListItem.dart';
import 'package:workout_tracker/services/DatabaseHelper.dart';

class ExercisesList extends StatefulWidget {
  ExercisesList();

  @override
  _ExercisesListState createState() => _ExercisesListState();
}

class _ExercisesListState extends State<ExercisesList> {
  late DatabaseHelper dbHelper;
  late List<Exercise> exercises;

  void _getAllExercises() async {
    await dbHelper.initializeDB();
    _showSnackBar(context: context, message: 'Fetching exercises...');
    exercises = await dbHelper.fetchExercises();
    setState(() {});
    _showSnackBar(context: context, message: 'Exercises loaded');
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    exercises = [];
    _getAllExercises();
  }

  void _upsertExercise(Exercise exercise) async {
    _showSnackBar(context: context, message: 'Adding exercise...');
    Exercise newExercise = await dbHelper.upsertExercise(exercise);
    setState(() {
      exercises.remove(exercise);
      exercises.add(newExercise);
    });
    _showSnackBar(context: context, message: 'Exercise added');
  }

  Future<void> _deleteExercise(Exercise exercise) async {
    await dbHelper.deleteExercise(exercise);
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to delete this exercise?\n\nWARNING: Any workout sets using this exercise will also be deleted.'),
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

  void _navigateToAddExercise(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddExerciseForm(
        upsert: _upsertExercise,
      ),
    ));
  }

  void _showSnackBar(
      {required BuildContext context,
      required String message,
      SnackBarAction? action,
      Function? handleOnDismissed}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), action: action))
        .closed
        .then((reason) {
      if (handleOnDismissed != null) handleOnDismissed(reason);
    });
  }

  @override
  Widget build(BuildContext context) {
    exercises.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) => ExerciseListItem(
          exercise: exercises[index],
          updateExercise: _upsertExercise,
          deleteExercise: () async {
            Exercise exercise = exercises[index];
            if ((await _confirmDelete(context)) ?? false) {
              setState(() => exercises.remove(exercise));
              _showSnackBar(
                context: context,
                message: 'Deleted exercise',
                action: new SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() => exercises.insert(index, exercise));
                  },
                ),
                handleOnDismissed: (reason) async {
                  if (reason != SnackBarClosedReason.action) {
                    await _deleteExercise(exercise);
                  }
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () => _navigateToAddExercise(context),
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          )),
    );
  }
}
