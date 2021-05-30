import 'package:intl/intl.dart';
import 'package:workout_tracker/models/Log.dart';

class Workout {
  int id;
  String name;
  DateTime? dateTime;

  late List<Log> logs;

  Workout({
    id,
    name,
    this.dateTime,
  })  : this.id = id ?? -1,
        this.name = name ?? '';

  Workout.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"].trim(),
        dateTime = DateTime.parse(res["dateTime"].trim());

  Map<String, dynamic?> toMap() {
    return {
      'name': name.trim(),
      if (dateTime != null)
        'dateTime': DateFormat('yyyy-MM-dd hh:mm').format(dateTime!).toString()
    };
  }
}
