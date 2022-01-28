import 'package:workout_tracker/models/Exercise.dart';

class ExerciseSet extends Exercise {
  List<ProgressionSet> sets;

  ExerciseSet({required Exercise exercise, required this.sets})
      : super(
            id: exercise.id,
            name: exercise.name,
            progressions: exercise.progressions);

  ExerciseSet.empty() : this(exercise: Exercise.empty(), sets: []);

  ExerciseSet.fromMap(Map<String, dynamic> map, {List<ProgressionSet>? sets})
      : this.sets = sets ?? [],
        super.fromMap(map);

  void setExercise(Exercise exercise) {
    this.id = exercise.id;
    this.name = exercise.name;
    this.progressions = exercise.progressions;
  }
}

class ProgressionSet extends Progression {
  int reps;

  ProgressionSet({required Progression progression, required this.reps})
      : super(
            id: progression.id,
            exerciseId: progression.exerciseId,
            name: progression.name,
            rank: progression.rank);

  ProgressionSet.empty() : this(progression: Progression.empty(), reps: 0);

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

  void setProgression(Progression progression) {
    this.id = progression.id;
    this.name = progression.name;
    this.exerciseId = progression.exerciseId;
    this.rank = progression.rank;
  }
}
