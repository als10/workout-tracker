import 'package:intl/intl.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class Workout {
  int? id;
  DateTime dateTime;
  List<ExerciseSet> sets;

  Workout({this.id,
    DateTime? dateTime,
    List<ExerciseSet>? sets})
      : this.dateTime = dateTime ?? DateTime.now(),
        this.sets = sets ?? [];

  Workout.fromMap(Map<String, dynamic> map, {List<ExerciseSet>? sets})
      : this(id: map["id"],
      dateTime: DateTime.parse(map["dateTime"].trim()),
      sets: sets);

  Map<String, dynamic> toMap() {
    return {
      'dateTime': DateFormat('yyyy-MM-dd hh:mm').format(this.dateTime).toString()
    };
  }
}
