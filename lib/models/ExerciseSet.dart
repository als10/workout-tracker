import 'package:workout_tracker/models/Exercise.dart';

class ExerciseSet extends Exercise {
  List<ProgressionSet> sets;

  ExerciseSet({required Exercise exercise, required this.sets})
      : super(
            id: exercise.id,
            name: exercise.name,
            progressions: exercise.progressions);

  ExerciseSet.fromMap(Map<String, dynamic> map, {List<ProgressionSet>? sets})
      : this.sets = sets ?? [],
        super.fromMap(map);
}

class ProgressionSet extends Progression {
  int reps;

  ProgressionSet({required Progression progression, required this.reps})
      : super(
            id: progression.id,
            exerciseId: progression.exerciseId,
            name: progression.name,
            rank: progression.rank);

  ProgressionSet.fromMap(Map<String, dynamic> map, {int reps = 0})
      : this.reps = reps,
        super.fromMap(map);

  Map<String, dynamic> toMap({int? workoutId}) {
    return {
      'reps': this.reps,
      'progressionId': this.id,
      'exerciseId': this.exerciseId,
      if(workoutId != null) 'workoutId': workoutId,
    };
  }
}
