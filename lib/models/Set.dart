// import 'package:workout_tracker/models/Exercise.dart';
//
// class Set {
//   int id;
//   int workoutId;
//   int reps;
//   Exercise exercise;
//
//   Set(
//       {required this.id,
//       required this.workoutId,
//       required int exerciseId,
//       required String exerciseName,
//       required Map<String, dynamic> progression,
//       this.reps = 0})
//       : this.exercise = Exercise(
//             id: exerciseId, name: exerciseName, progressions: progressions);
//
//   Set.new(
//   {required int exerciseId,
//   required String exerciseName,
//   required List<Map<String, dynamic>> progressions,
//   this.reps = 0}
//   )
//
//   Set.fromMap(Map<String, dynamic> res)
//       : this.id = res["id"],
//         this.workoutId = res["workoutId"],
//         this.reps = res["reps"],
//         this.exercise = res["exercise"];
//
//   Map<String, dynamic?> toMap() {
//     return {
//       'workoutId': workoutId,
//       'progressionId': exercise.progressions[0].id,
//       'reps': reps,
//     };
//   }
// }
