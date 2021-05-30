import 'package:intl/intl.dart';
import 'package:workout_tracker/models/Log.dart';

class Workout {
  int id;
  String name;
  DateTime dateTime;

  List<Log> logs = [];

  Workout({
    this.id = -1,
    this.name = '',
    dateTime,
  }) : this.dateTime = dateTime ?? DateTime.now();

  Workout.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"].trim(),
        dateTime = DateTime.parse(res["dateTime"].trim());

  Map<String, dynamic?> toMap() {
    return {
      'name': name.trim(),
      'dateTime': DateFormat('yyyy-MM-dd hh:mm').format(dateTime).toString()
    };
  }
}
