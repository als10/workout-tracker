import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';
import 'package:workout_tracker/services/DatabaseHelper.dart';
import 'components/WorkoutListItem.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  late DatabaseHelper dbHelper;
  late List<Workout> workouts;

  void getAllWorkouts() async {
    await dbHelper.initializeDB();
    workouts = await dbHelper.fetchWorkouts();
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    workouts = [];
    getAllWorkouts();
  }

  void addWorkout({String? workoutName, List<Log>? logs}) async {
    Workout newWorkout = await dbHelper.insertWorkout(Workout(name: workoutName));

    List<Log> newLogs = [];
    (logs ?? []).forEach((Log log) async {
      Exercise newExercise = await dbHelper.insertExercise(Exercise(name: log.exercise.name));
      log.workout = newWorkout;
      log.exercise = newExercise;
      dbHelper.insertLog(log).then((l) => newLogs.add(l));
    });

    setState(() {
      newWorkout.logs = newLogs;
      workouts.add(newWorkout);
    });
  }

  void _navigateToAddWorkout(BuildContext context) {
    Navigator.pushNamed(
      context,
      AddWorkoutForm.routeName,
      arguments: addWorkout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: workouts.map((Workout workout) {
          return Column(
            children: [
              WorkoutListItem(workout: workout),
              Divider(),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () => _navigateToAddWorkout(context),
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          )
      ),
    );
  }
}