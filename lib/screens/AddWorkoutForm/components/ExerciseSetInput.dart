import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ExerciseInput.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ProgressionSetInput.dart';

class ExerciseSetInput extends StatelessWidget {
  ExerciseSet set;
  Function? delete;
  ExerciseSetInput({required this.set, this.delete});

  @override
  Widget build(BuildContext context) {
    List<Widget> _progressionInputs = set.sets.map((ProgressionSet pset) =>
        ProgressionSetInput(set: pset)
    ).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ExerciseInput(exercise: Exercise(id: set.id, name: set.name), setExercise: (Exercise exercise) => set.setExercise(exercise)),
          ..._progressionInputs,
          if (delete != null)
            ElevatedButton(
              onPressed: () => delete!(),
              child: Text('Delete Exercise'),
            ),
        ],
      ),
    );
  }
}
