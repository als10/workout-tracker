import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Workout.dart';

class Log {
  int id;
  Workout workout;
  Exercise exercise;
  int sets;
  int reps;

  Log({
    id,
    workout,
    exercise,
    sets,
    reps,
  }) : this.workout = workout ?? Workout(),
       this.exercise = exercise ?? Exercise(),
       this.id = id ?? -1,
       this.sets = sets ?? 0,
       this.reps = reps ?? 0;

  Log.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      workout = Workout(id: res["workoutId"]),
      exercise = Exercise(id: res["exerciseId"]),
      sets = res["sets"],
      reps = res["reps"];

  Map<String, Object?> toMap() {
    return {
      'workoutId': workout.id,
      'exerciseId': exercise.id,
      'sets': sets,
      'reps': reps,
    };
  }

  // void print_() {
  //   print('Log');
  //   print('id ${id}');
  //   print('workout ${workout!.id}');
  //   print('exercise');
  //   exercise.print_();
  //   print('sets ${sets}');
  //   print('reps ${reps}');
  // }
}