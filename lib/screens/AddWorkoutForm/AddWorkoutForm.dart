import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/LogInputs.dart';

class AddWorkoutForm extends StatefulWidget {
  static const routeName = '/AddWorkoutForm';

  @override
  AddWorkoutFormState createState() => AddWorkoutFormState();
}

class AddWorkoutFormState extends State<AddWorkoutForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  static Map<String, dynamic> defaultLog = {
    'exerciseName': '',
    'sets': 0,
    'reps': 0
  };

  static List<Map<String, dynamic>> logsList = [defaultLog];

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  void _save(context) {
    final Function addWorkout = ModalRoute.of(context)!.settings.arguments as Function;
    addWorkout(logs: logsList);
    logsList = [defaultLog];
    Navigator.of(context).pop();
  }

  List<Widget> _getExercises() {
    List<Widget> logsInputFieldsList = [];
    for(int i = 0; i < logsList.length; i++) {
      logsInputFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              LogInputs(logsList, i),
              if (logsList.length > 1)
                ElevatedButton(
                onPressed: () {
                  logsList.removeAt(i);
                  setState((){});
                },
                child: Text('Remove exercise'),
              ),
            ],
          ),
        ),
      );
    }
    return logsInputFieldsList;
  }

  Widget exerciseInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getExercises(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                logsList.add(defaultLog);
                setState((){});
              },
              child: Text('Add another exercise'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Name'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => _save(context),)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: exerciseInput(),
        ),
      ),
    );
  }
}