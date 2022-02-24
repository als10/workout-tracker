import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ProgressionSetInput.dart';

class ExerciseSetInput extends StatefulWidget {
  ExerciseSet set;
  Function navigateToChooseExercise;

  ExerciseSetInput(
      {required this.set, required this.navigateToChooseExercise});

  @override
  _ExerciseSetInputState createState() => _ExerciseSetInputState();
}

class _ExerciseSetInputState extends State<ExerciseSetInput> {
  List<Widget> _progressionInputs(ExerciseSet set) =>
    set.sets.asMap()
      .map((int i, ProgressionSet pset) =>
      MapEntry(
        i,
        Padding(
          padding: EdgeInsets.all(4),
          child: ProgressionSetInput(
            index: i,
            set: pset,
            progressions: set.progressions,
            delete: set.sets.length > 1
                ? () => setState(() => set.sets.remove(pset))
                : null,
          ),
        ),
      )).values.toList();

  @override
  Widget build(BuildContext context) {
    ExerciseSet set = widget.set;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Text(
                    set.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
                ),
                Divider(),
                ..._progressionInputs(set),
              ],
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => setState(() => set.sets.add(ProgressionSet.empty())),
          icon: Icon(Icons.add),
          label: Text('Add set'),
        ),
      ],
    );
  }
}
