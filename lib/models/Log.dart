import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Workout.dart';

class Log {
  int id;
  int workoutId;
  int sets;
  int reps;
  Exercise exercise;

  Log({
    id,
    required this.workoutId,
    required exerciseId,
    required this.sets,
    required this.reps
  }) : this.id = id ?? -1,
       this.exercise = Exercise(id: exerciseId);

  Log.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      workoutId = res["workoutId"],
      exercise = Exercise(id: res["exerciseId"]),
      sets = res["sets"],
      reps = res["reps"];

  Map<String, dynamic?> toMap() {
    return {
      'workoutId': workoutId,
      'exerciseId': exercise.id,
      'sets': sets,
      'reps': reps,
    };
  }
}