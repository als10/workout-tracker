import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ProgressionSetInput.dart';

class ExerciseSetInput extends StatefulWidget {
  ExerciseSet set;
  Function? delete;
  Function navigateToChooseExercise;

  ExerciseSetInput(
      {required this.set, this.delete, required this.navigateToChooseExercise});

  @override
  _ExerciseSetInputState createState() => _ExerciseSetInputState();
}

class _ExerciseSetInputState extends State<ExerciseSetInput> {
  @override
  Widget build(BuildContext context) {
    ExerciseSet set = widget.set;

    List<Widget> _progressionInputs = set.sets
        .map((ProgressionSet pset) =>
            ProgressionSetInput(set: pset, progressions: set.progressions))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              Exercise? selectedExercise =
                  await widget.navigateToChooseExercise(context);
              if (selectedExercise != null) {
                setState(() {
                  set.setExercise(selectedExercise);
                  set.sets = [ProgressionSet.empty()];
                });
              }
            },
            child: Text(set.name),
          ),
          ..._progressionInputs,
          if (widget.delete != null)
            ElevatedButton(
              onPressed: () => widget.delete!(),
              child: Text('Delete Exercise'),
            ),
        ],
      ),
    );
  }
}
