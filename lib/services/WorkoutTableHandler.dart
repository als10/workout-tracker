// import 'package:sqflite/sqflite.dart';
// import 'package:workout_tracker/models/Workout.dart';
// import 'package:workout_tracker/services/ExerciseTableHandler.dart';
//
// class WorkoutTableHandler {
//   final Database database;
//
//   final ExerciseTableHandler exerciseTableHandler = new ExerciseTableHandler(database: database);
//   static const String TABLE_NAME = 'workouts';
//
//   WorkoutTableHandler({
//     required this.database,
//   });
//
//   Future<Workout> insert(Workout workout) async {
//     int id = await database.insert(
//         TABLE_NAME,
//         workout.toMap()
//     );
//     return fetchById(id);
//   }
//
//   Future<List<Workout>> fetchAll() async {
//     final List<Map<String, Object?>> workoutsMapList = await database.query(TABLE_NAME);
//     List<Workout> workoutsList = workoutsMapList.map((workoutMap) {
//       Workout workout = Workout.fromMap(workoutMap);
//       workout.exercises =
//     });
//
//     return result
//         .map((workout) => Workout.fromMap(workout))
//         .toList();
//   }
//
//   Future<Workout> fetchById(int id) async {
//     final List<Map<String, Object?>> result = await database.query(
//         TABLE_NAME,
//         where: 'id = ?',
//         whereArgs: [id]
//     );
//     return Workout.fromMap(result[0]);
//   }
//
//   Future<Workout> update(Workout workout) async {
//     await database.update(
//       TABLE_NAME,
//       workout.toMap(),
//       where: 'id = ?',
//       whereArgs: [workout.id],
//     );
//     return workout;
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