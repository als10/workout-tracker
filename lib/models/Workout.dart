import 'package:workout_tracker/models/Log.dart';

class Workout {
  int id;
  String name;
  String dateTime;

  late List<Log> logs;

  Workout({
    id,
    name,
    dateTime,
  }) : this.id = id ?? -1,
       this.name = name ?? '',
       this.dateTime = dateTime ?? '';

  Workout.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      name = res["name"].trim(),
      dateTime = res["dateTime"].trim();

  Map<String, dynamic?> toMap() {
    return {
      'name': name.trim(),
      if (dateTime != '') 'dateTime': dateTime.trim()
    };
  }
}