import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/LogInputs.dart';

class AddWorkoutForm extends StatefulWidget {
  static const routeName = '/AddWorkoutForm';

  @override
  AddWorkoutFormState createState() => AddWorkoutFormState();
}

class AddWorkoutFormState extends State<AddWorkoutForm> {
  late final TextEditingController nameController;
  late final TextEditingController setsController;
  late final TextEditingController repsController;

  static const Map<String, dynamic> defaultLog = {
    'exerciseName': '',
    'sets': 0,
    'reps': 0
  };

  static List<Map<String, dynamic>> logsList = [defaultLog];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController();
    setsController = TextEditingController();
    repsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  void _save(context) {
    if (_formKey.currentState!.validate()) {
      final Function addWorkout =
          ModalRoute.of(context)!.settings.arguments as Function;
      addWorkout(logs: logsList);
      logsList = [defaultLog];
      Navigator.of(context).pop();
    }
  }

  void changeLog(
      {required int index, String? exerciseName, int? sets, int? reps}) {
    logsList[index] = {
      ...logsList[index],
      if (exerciseName != null) 'exerciseName': exerciseName,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps
    };
  }

  List<Widget> _getExercises() {
    List<Widget> logsInputFieldsList = [];
    for (int i = 0; i < logsList.length; i++) {
      logsInputFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              LogInputs(i, changeLog),
              if (logsList.length > 1)
                ElevatedButton(
                  onPressed: () {
                    logsList.removeAt(i);
                    setState(() {});
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
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getExercises(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  logsList = [...logsList, defaultLog];
                  setState(() {});
                }
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
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _save(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: exerciseInput(),
          ),
        ),
      ),
    );
  }
}
