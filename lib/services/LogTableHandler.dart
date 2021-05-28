// import 'package:sqflite/sqflite.dart';
// import 'package:workout_tracker/models/Exercise.dart';
// import 'package:workout_tracker/models/ExerciseType.dart';
// import 'package:workout_tracker/models/Log.dart';
// import 'package:workout_tracker/models/Workout.dart';
// import 'package:workout_tracker/services/ExerciseTableHandler.dart';
// import 'package:workout_tracker/services/WorkoutTableHandler.dart';
//
// class LogTableHandler {
//   final Database database;
//
//   final ExerciseTableHandler _exerciseTableHandler = ExerciseTableHandler(database: database);
//   final WorkoutTableHandler _workoutTableHandler = WorkoutTableHandler(database: database);
//   static const String TABLE_NAME = 'logs';
//
//   LogTableHandler({
//     required this.database,
//   });
//
//   Future<Log> insert(Log log) async {
//     int id = await database.insert(
//         TABLE_NAME,
//         log.toMap()
//     );
//     return fetchById(id);
//   }
//
//   Future<List<Log>> fetchAll() async {
//     final logMapList = await database.query('logs');
//     final logList = logMapList.map((logMap) async {
//       var log = Log.fromMap(logMap);
//
//       final workoutMapList = await database.query(
//         'workouts',
//         where: 'id = ?',
//         whereArgs: [log.workoutId],
//       );
//       final workout = Workout.fromMap(workoutMapList[0]);
//
//       final exerciseMapList = await database.query(
//         'exercises',
//         where: 'id = ?',
//         whereArgs: [log.exerciseId],
//       );
//       var exercise = Exercise.fromMap(exerciseMapList[0]);
//
//       final exerciseTypeMapList = await database.query(
//         'exerciseTypes',
//         where: 'id = ?',
//         whereArgs: [exercise.typeId],
//       );
//       final exerciseType = ExerciseType.fromMap(exerciseTypeMapList[0]);
//
//       exercise.type = exerciseType.type;
//
//       return log;
//     });
//     return result
//         .map((log) => Log.fromMap(log))
//         .toList();
//   }
//
//   Future<Log> fetchById(int id) async {
//     final List<Map<String, Object?>> result = await database.query(
//         TABLE_NAME,
//         where: 'id = ?',
//         whereArgs: [id]
//     );
//     return Log.fromMap(result[0]);
//   }
//
//   Future<Log> update(Log log) async {
//     await database.update(
//       TABLE_NAME,
//       log.toMap(),
//       where: 'id = ?',
//       whereArgs: [log.id],
//     );
//     return log;
//   }
//
//   Future<void> delete(int id) async {
//     await database.delete(
//       TABLE_NAME,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }