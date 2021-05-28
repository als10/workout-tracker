import 'package:workout_tracker/models/Log.dart';

class Workout {
  int id;
  String name;
  String dateTime;
  List<Log> logs = [];

  Workout({
    id,
    name,
    dateTime,
    logs
  }) : this.id = id ?? -1,
       this.name = name ?? '',
       this.dateTime = dateTime ?? '',
       this.logs = logs ?? [];

  Workout.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      name = res["name"],
      dateTime = res["dateTime"];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      if (dateTime != '') 'dateTime': dateTime
    };
  }

  // void print_() {
  //   print('Workout');
  //   print('id ${id}');
  //   print('name ${name}');
  //   print('dateTime ${dateTime}');
  //   logs!.forEach((log) {
  //     print('log');
  //     log.print_();
  //   });
  // }
}