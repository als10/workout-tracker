import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/DateTimePicker.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ExerciseSetInput.dart';
import 'package:workout_tracker/screens/ExercisesList/ExercisesList.dart';

class AddWorkoutForm extends StatefulWidget {
  final Function upsert;
  final Workout? workout;

  AddWorkoutForm({required this.upsert, this.workout});

  @override
  AddWorkoutFormState createState() => AddWorkoutFormState();
}

class AddWorkoutFormState extends State<AddWorkoutForm> {
  late Workout workout;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    workout = widget.workout ?? Workout();
    super.initState();
  }

  void _save(context) {
    if (_formKey.currentState!.validate()) {
      widget.upsert(workout);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate =
        await DateTimePicker.selectDate(context, workout.dateTime);
    if (pickedDate != null && pickedDate != workout.dateTime) {
      setState(() {
        workout.dateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, workout.dateTime.hour, workout.dateTime.minute);
      });
    }

    TimeOfDay? pickedTime = await DateTimePicker.selectTime(
        context, TimeOfDay.fromDateTime(workout.dateTime));
    if (pickedTime != null &&
        pickedTime != TimeOfDay.fromDateTime(workout.dateTime)) {
      setState(() {
        workout.dateTime = DateTime(
            workout.dateTime.year,
            workout.dateTime.month,
            workout.dateTime.day,
            pickedTime.hour,
            pickedTime.minute);
      });
    }
  }

  Future<Exercise?> _navigateToChooseExercise(BuildContext context) async {
    return await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ExercisesList()));
  }

  List<Widget> _getExercises() => workout.sets
      .map((ExerciseSet set) =>
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ExerciseSetInput(
              set: set,
              navigateToChooseExercise: _navigateToChooseExercise,
            ),
          ),
        )
      ).toList();

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today_rounded, color: Colors.blue),
              onPressed: () => _selectDateTime(context),
            ),
            Text(
              DateFormat('h:mm a, d MMM').format(workout.dateTime),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.save, color: Colors.blue),
              onPressed: () => _save(context),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: controller,
          children: _getExercises(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (workout.sets.length > 1)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => workout.sets.removeAt(controller.page!.toInt())),
                    icon: Icon(Icons.delete),
                    label: Text('Remove Exercise'),
                  ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    Exercise? selectedExercise =
                    await _navigateToChooseExercise(context);
                    if (selectedExercise != null) {
                      setState(() {
                        workout.sets.add(ExerciseSet(
                            exercise: selectedExercise,
                            sets: [ProgressionSet.empty()]));
                        controller.jumpToPage(workout.sets.length);
                      });
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Exercise'),
                ),
              ],
            ),
            SizedBox(height: 8),
            SmoothPageIndicator(
              controller: controller,
              count:  workout.sets.length,
              effect:  WormEffect(activeDotColor: Colors.blue, radius: 8),
              onDotClicked: (int i) => controller.jumpToPage(i),
            )
          ],
        ),
      )
    );
  }
}
