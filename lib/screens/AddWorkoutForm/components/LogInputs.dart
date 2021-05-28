import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ExerciseNameInput.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/SetsAndRepsInput.dart';

class LogInputs extends StatefulWidget {
  final int index;
  final Function changeLog;

  LogInputs(this.index, this.changeLog);

  @override
  _LogInputsState createState() => _LogInputsState();
}

class _LogInputsState extends State<LogInputs> {
  late final TextEditingController nameController;
  late final TextEditingController setsController;
  late final TextEditingController repsController;

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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> log = AddWorkoutFormState.logsList[widget.index];

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      nameController.text = log['exerciseName'];
      setsController.text = log['sets'].toString();
      repsController.text = log['reps'].toString();
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ExerciseNameInput(
        controller: nameController,
        onChange: (v) => widget.changeLog(index: widget.index, exerciseName: v),
      ),
      SetsAndRepsInput(
        setsController: setsController,
        repsController: repsController,
        onSetsChange: (v) =>
            widget.changeLog(index: widget.index, sets: int.parse(v)),
        onRepsChange: (v) =>
            widget.changeLog(index: widget.index, reps: int.parse(v)),
      )
    ]);
  }
}
