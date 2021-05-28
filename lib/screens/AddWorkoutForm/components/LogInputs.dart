import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ExerciseNameInput.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/SetsAndRepsInput.dart';

class LogInputs extends StatefulWidget {
  final int index;

  LogInputs(this.index);

  @override
  _LogInputsState createState() => _LogInputsState();
}

class _LogInputsState extends State<LogInputs> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> log = AddWorkoutFormState.logsList[widget.index];

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      nameController.text = log['exerciseName'];
      setsController.text = log['sets'].toString();
      repsController.text = log['reps'].toString();
    });

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExerciseNameInput(
            controller: nameController,
            onChange: (v) => log['exerciseName'] = v,
          ),
          SetsAndRepsInput(
            setsController: setsController,
            repsController: repsController,
            onSetsChange: (v) => log['sets'] = int.parse(v),
            onRepsChange: (v) => log['reps'] = int.parse(v)
          ),
        ]
    );
  }
}