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

  void _save(context) {
    if (_formKey.currentState!.validate()) {
      widget.upsert(exercise);
      Navigator.of(context).pop();
    }
  }

  List<Widget> _progressionInputs() => exercise.progressions
      .map((Progression p) => ProgressionInput(
            initialValue: p.name,
            onChange: (v) => p.name = v,
            deleteProgression: exercise.progressions.length > 1
                ? () => setState(() => exercise.progressions.remove(p))
                : null,
          ))
      .toList();

  Widget _exerciseInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseNameInput(
            initialValue: exercise.name, onChange: (v) => exercise.name = v),
        ..._progressionInputs(),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() => exercise.progressions.add(Progression.empty(
                    rank: exercise.progressions.length,
                    exerciseId: exercise.id ?? -1)));
              }
            },
            child: Text('Add another progression'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
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
            child: _exerciseInput(),
          ),
        ),
      ),
    );
  }
}
