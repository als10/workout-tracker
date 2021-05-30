import 'package:workout_tracker/models/Exercise.dart';

class Log {
  int id;
  int workoutId;
  int sets;
  int reps;
  Exercise exercise;

  Log(
      {this.id = -1,
      this.workoutId = -1,
      exerciseId,
      exerciseName,
      this.sets = 0,
      this.reps = 0})
      : this.exercise = exerciseId != null
            ? Exercise(id: exerciseId)
            : exerciseName != null
                ? Exercise(name: exerciseName)
                : Exercise();

  Log.fromMap(Map<String, dynamic> res)
      : id = res["id"],
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
