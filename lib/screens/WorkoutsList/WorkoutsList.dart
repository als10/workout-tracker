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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    workouts = [];
    getAllWorkouts();
  }

  void _addWorkout(
      {String? workoutName, List<Map<String, dynamic>>? logs}) async {
    _showSnackbar(context: context, message: 'Adding workout...');

    Workout newWorkout =
        await dbHelper.insertWorkout(Workout(name: workoutName ?? ''));

    List<Log> newLogs = [];
    for (Map<String, dynamic> log in (logs ?? [])) {
      if (log['exerciseName'] != '') {
        Exercise exercise =
          await dbHelper.insertExercise(Exercise(name: log['exerciseName']));
        Log newLog = await dbHelper.insertLog(Log(
            workoutId: newWorkout.id,
            exerciseId: exercise.id,
            sets: log['sets'],
            reps: log['reps']));
        newLog.exercise = exercise;
        newLogs.add(newLog);
      }
    }

    newWorkout.logs = newLogs;
    print(newLogs.length);

    setState(() {
      workouts.insert(0, newWorkout);
    });
    _showSnackbar(context: context, message: 'Workout added');
  }
  
  void _deleteWorkout(Workout workout) {
    dbHelper.deleteWorkout(workout);
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to delete this workout?'),
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

  void _navigateToAddWorkout(BuildContext context) {
    Navigator.pushNamed(
      context,
      AddWorkoutForm.routeName,
      arguments: _addWorkout,
    );
  }

  void _showSnackbar(
      {required BuildContext context,
        required String message,
        SnackBarAction? action,
        Function? handleOnDismissed
      }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message),
          action: action
        ))
        .closed
        .then((reason) {
          if (handleOnDismissed != null) handleOnDismissed(reason);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final Workout workout = workouts[index];
          return Dismissible(
            confirmDismiss: (direction) => _confirmDelete(context),
            direction: DismissDirection.endToStart,
            key: Key(workout.id.toString()),
            onDismissed: (direction) {
              setState(() {
                workouts.removeAt(index);
              });
              _showSnackbar(
                context: context,
                message: 'Deleted workout',
                action: new SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() => workouts.insert(index, workout));
                  },
                ),
                handleOnDismissed: (reason) {
                  if (reason != SnackBarClosedReason.action) {
                    _deleteWorkout(workout);
                  }
                }
              );
              // ScaffoldMessenger.of(context).removeCurrentSnackBar();
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(
              //       content: Text('Deleted workout'),
              //       action: new SnackBarAction(
              //         label: 'UNDO',
              //         onPressed: () {
              //           setState(() {
              //             workouts.insert(index, workout);
              //           });
              //         },
              //       ),
              //     ))
              //     .closed
              //     .then((reason) {
              //       if (reason != SnackBarClosedReason.action) {
              //         _deleteWorkout(workout);
              //       }
              //     });
            },
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: WorkoutListItem(workout: workout),
          );
        },
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () => _navigateToAddWorkout(context),
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          )),
    );
  }
}
