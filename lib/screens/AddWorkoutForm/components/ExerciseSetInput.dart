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
          padding: EdgeInsets.symmetric(horizontal: 4),
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'EXERCISE',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ),
              Card(
                child: TextButton(
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      set.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
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
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'SETS',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _progressionInputs(set),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: OutlinedButton.icon(
            onPressed: () => setState(() => set.sets.add(ProgressionSet.empty())),
            icon: Icon(Icons.add),
            label: Text('Add set'),
          ),
        ),
      ],
    );
  }
}
