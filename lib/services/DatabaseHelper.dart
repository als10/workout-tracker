import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';
import 'package:workout_tracker/models/Workout.dart';

class DatabaseHelper {
  late Database db;

  void _createTables(database, version) async {
    await database.execute('''
          CREATE TABLE workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dateTime DATETIME DEFAULT CURRENT_TIMESTAMP
        )''');

    await database.execute('''
          CREATE TABLE exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE
        )''');

    await database.execute('''
          CREATE TABLE progressions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          rank INT NOT NULL,
          exerciseId INTEGER NOT NULL,
          FOREIGN KEY (exerciseId) REFERENCES exercises (id) ON DELETE CASCADE
        )''');

    await database.execute('''
          CREATE TABLE sets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          reps INTEGER NOT NULL DEFAULT 0,
          workoutId INTEGER NOT NULL,
          progressionId INTEGER NOT NULL,
          exerciseId INTEGER NOT NULL,
          FOREIGN KEY (workoutId) REFERENCES workouts (id) ON DELETE CASCADE,
          FOREIGN KEY (progressionId) REFERENCES progressions (id) ON DELETE CASCADE,
          FOREIGN KEY (exerciseId) REFERENCES exercises (id) ON DELETE CASCADE
        )''');
  }

  // path: /data/user/0/com.alstondmello.workout_tracker/databases
  Future<void> initializeDB() async {
    String path = await getDatabasesPath();
    this.db = await openDatabase(
      join(path, 'workoutTracker.db'),
      onCreate: _createTables,
      version: 1,
    );
    await this.db.execute('PRAGMA foreign_keys = ON');
  }

  Future<List<Workout>> fetchWorkouts() async {
    List<Map<String, dynamic>> workoutsMapList = await db.query('workouts', orderBy: 'dateTime DESC');

    List<Workout> workouts = [];
    for (Map<String, dynamic> workoutMap in workoutsMapList) {
      List<Map<String, dynamic>> setsMapList = await db.query(
        'sets',
        where: 'workoutId = ?',
        whereArgs: [workoutMap['id']],
      );

      List<ExerciseSet> sets = [];
      Set<int> exerciseIdsAddedSoFar = Set();
      for (Map<String, dynamic> setMap in setsMapList) {
        Progression progression = (await fetchProgressions(progressionId: setMap['progressionId']))[0];
        ProgressionSet progressionSet = ProgressionSet(progression: progression, reps: setMap['reps']);

        int exerciseId = setMap['exerciseId'];
        late ExerciseSet set;
        if (exerciseIdsAddedSoFar.contains(exerciseId)) {
          set = sets.firstWhere((ExerciseSet set) => set.id == exerciseId);
          set.sets.add(progressionSet);
        } else {
          Exercise exercise = (await fetchExercises(exerciseId: exerciseId))[0];
          set = ExerciseSet(exercise: exercise, sets: [progressionSet]);
          sets.add(set);
          exerciseIdsAddedSoFar.add(exerciseId);
        }
      }

      workouts.add(Workout.fromMap(workoutMap, sets: sets));
    }
    return workouts;
  }

  Future<Workout> upsertWorkout(Workout workout) async {
    if (workout.id == null) {
      workout.id = await db.insert('workouts', workout.toMap());
      await insertSets(workout.sets, workoutId: workout.id!);
    } else {
      await db.update(
        'workouts',
        workout.toMap(),
        where: 'id = ?',
        whereArgs: [workout.id],
      );
      await updateSets(workout.sets, workoutId: workout.id!);
    }
    return workout;
  }

  Future<bool> deleteWorkout(Workout workout) async {
    await db.delete('workouts', where: 'id = ?', whereArgs: [workout.id]);
    return true;
  }

  Future<List<ExerciseSet>> insertSets(List<ExerciseSet> sets,
      {required int workoutId}) async {
    for (ExerciseSet eset in sets) {
      for (ProgressionSet pset in eset.sets) {
        await db.insert('sets', pset.toMap(workoutId: workoutId));
      }
    }
    return sets;
  }

  Future<List<ExerciseSet>> updateSets(List<ExerciseSet> sets,
      {required int workoutId}) async {
    await db.delete('sets', where: 'workoutId = ?', whereArgs: [workoutId]);
    await insertSets(sets, workoutId: workoutId);
    return sets;
  }

  Future<List<Exercise>> fetchExercises({int? exerciseId}) async {
    List<Map<String, dynamic>> exerciseMapList = exerciseId == null
      ? await db.query('exercises')
      : await db.query('exercises', where: 'id = ?', whereArgs: [exerciseId]);

    List<Exercise> exercises = [];
    for (Map<String, dynamic> exerciseMap in exerciseMapList) {
      List<Progression> progressions = await fetchProgressions(exerciseId: exerciseMap['id']);
      exercises.add(Exercise.fromMap(exerciseMap, progressions: progressions));
    }
    return exercises;
  }

  Future<Exercise> upsertExercise(Exercise exercise) async {
    if (exercise.id == null) {
      exercise.id = await db.insert('exercises', exercise.toMap());
    } else {
      await db.update('exercises', exercise.toMap(),
          where: 'id = ?', whereArgs: [exercise.id]);
    }

    exercise.progressions = await Future.wait(exercise.progressions
        .map((Progression progression) async =>
            await upsertProgression(progression, exerciseId: exercise.id))
        .toList());

    return exercise;
  }

  Future<bool> deleteExercise(Exercise exercise) async {
    await db.delete('exercises', where: 'id = ?', whereArgs: [exercise.id]);
    return true;
  }

  Future<List<Progression>> fetchProgressions({int? exerciseId, int? progressionId}) async {
    List<Map<String, dynamic>> progressionMapList = exerciseId == null && progressionId == null
      ? await db.query('progressions')
      : await db.query(
        'progressions',
        where: exerciseId != null ? 'exerciseId = ?' : 'id = ?',
        whereArgs: exerciseId != null ? [exerciseId] : [progressionId]);
    List<Progression> progressions = progressionMapList
        .map((Map<String, dynamic> progressionMap) =>
        Progression.fromMap(progressionMap))
        .toList();
    return progressions;
  }

  Future<Progression> upsertProgression(Progression progression,
      {int? exerciseId}) async {
    if (exerciseId != null) progression.exerciseId = exerciseId;
    if (progression.id == null) {
      progression.id = await db.insert('progressions', progression.toMap());
    } else {
      await db.update('progressions', progression.toMap(),
          where: 'id = ?', whereArgs: [progression.id]);
    }
    return progression;
  }

  Future<bool> deleteProgression(Progression progression) async {
    await db
        .delete('progressions', where: 'id = ?', whereArgs: [progression.id]);
    return true;
  }
}
