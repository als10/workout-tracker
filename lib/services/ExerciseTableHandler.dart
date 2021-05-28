// import 'package:sqflite/sqflite.dart';
// import 'package:workout_tracker/models/Exercise.dart';
//
// class ExerciseTableHandler {
//   final Database database;
//
//   static const String TABLE_NAME = 'exercises';
//
//   ExerciseTableHandler({
//     required this.database,
//   });
//
//   Future<Exercise> insert(Exercise exercise) async {
//     int id = await database.insert(
//         TABLE_NAME,
//         exercise.toMap()
//     );
//     return fetchById(id);
//   }
//
//   Future<List<Exercise>> fetchAll() async {
//     final List<Map<String, Object?>> result = await database.query(TABLE_NAME);
//     return result
//         .map((exercise) => Exercise.fromMap(exercise))
//         .toList();
//   }
//
//   Future<Exercise> fetchById(int id) async {
//     final List<Map<String, Object?>> result = await database.query(
//         TABLE_NAME,
//         where: 'id = ?',
//         whereArgs: [id]
//     );
//     return Exercise.fromMap(result[0]);
//   }
//
//   Future<Exercise> update(Exercise exercise) async {
//     await database.update(
//       TABLE_NAME,
//       exercise.toMap(),
//       where: 'id = ?',
//       whereArgs: [exercise.id],
//     );
//     return exercise;
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