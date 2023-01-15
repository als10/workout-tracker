import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/screens/AddExerciseForm/components/ExerciseNameInput.dart';
import 'package:workout_tracker/screens/AddExerciseForm/components/ProgressionInput.dart';

class AddExerciseForm extends StatefulWidget {
  final Function upsert;
  final Exercise? exercise;

  AddExerciseForm({required this.upsert, this.exercise});

  @override
  AddExerciseFormState createState() => AddExerciseFormState();
}

class AddExerciseFormState extends State<AddExerciseForm> {
  late Exercise exercise;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    exercise = widget.exercise ?? Exercise.empty();
    super.initState();
  }

  void _save(context) async {
    if (_formKey.currentState!.validate() && ((await _confirmSave(context)) ?? false)) {
      exercise.updateRanks();
      await widget.upsert(exercise);
      Navigator.of(context).pop();
    }
  }

  Future<bool?> _confirmClose(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Any changes will be discarded.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text('Discard'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    );
  }

  Future<bool?> _confirmSave(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Workouts associated with any deleted progressions will be deleted.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    );
  }

  Widget _exerciseInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseNameInput(
            initialValue: exercise.name, onChange: (v) => exercise.name = v),
        ProgressionInputs(progressions: exercise.progressions),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: OutlinedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() => exercise.progressions.add(Progression.empty(
                    rank: exercise.progressions.length,
                    exerciseId: exercise.id ?? -1)));
              }
            },
            icon: Icon(Icons.add),
            label: Text('Add progression'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            if ((await _confirmClose(context)) ?? false) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text('Add Exercise'),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.blue),
            onPressed: () => _save(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _exerciseInput(),
          ),
        ),
      ),
    );
  }
}
