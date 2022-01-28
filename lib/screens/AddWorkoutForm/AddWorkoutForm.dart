import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/DateTimePicker.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/ExerciseSetInput.dart';

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

  List<Widget> _getExercises() =>
    workout.sets.map((ExerciseSet set) =>
        ExerciseSetInput(
          set: set,
          delete: workout.sets.length > 1
            ? () => setState(() => workout.sets.remove(set))
            : null,
        )
    ).toList();

  Widget _exerciseInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_today_rounded),
                onPressed: () => _selectDateTime(context),
              ),
              Text(DateFormat('h:mm a - MMM d, yyyy').format(workout.dateTime),
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
          ..._getExercises(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  workout.sets.add(ExerciseSet.empty());
                  setState(() {});
                }
              },
              child: Text('Add another exercise'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _save(context),
          ),
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
