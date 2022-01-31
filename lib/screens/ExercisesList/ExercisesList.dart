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
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: exercises.length,
        itemBuilder: (context, index) => ExerciseListItem(
            exercise: exercises[index], updateExercise: _upsertExercise),
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
