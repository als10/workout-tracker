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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProgressionSetInput(set: pset, progressions: set.progressions),
                  Column(
                    children: [
                      if (set.sets.length > 1)
                        IconButton(
                          onPressed: () => setState(() => set.sets.remove(pset)),
                          icon: Icon(Icons.delete),
                        ),
                      IconButton(
                        onPressed: () => setState(() => set.sets.add(ProgressionSet.empty())),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        runSpacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              if (widget.delete != null)
                IconButton(
                  onPressed: () => widget.delete!(),
                  icon: Icon(Icons.delete),
                ),
            ],
          ),
          ..._progressionInputs,
        ],
      ),
    );
  }
}
