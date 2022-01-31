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
          rank INT NOT NULL UNIQUE,
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

  Future<void> initializeDB() async {
    String path = await getDatabasesPath();
    this.db = await openDatabase(
      join(path, 'workoutTracker.db'),
      onCreate: _createTables,
      version: 1,
    );
  }

  Future<List<Workout>> fetchWorkouts() async {
    List<Map<String, dynamic>> workoutsMapList = await db.query('workouts');

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
        int exerciseId = setMap['exerciseId'];
        late ExerciseSet set;
        if (exerciseIdsAddedSoFar.contains(exerciseId)) {
          set = sets.firstWhere((ExerciseSet set) => set.id == exerciseId);
          sets.remove(set);
        } else {
          Map<String, dynamic> exerciseMap = (await db.query(
            'exercises',
            where: 'id = ?',
            whereArgs: [exerciseId],
          ))[0];
          set = ExerciseSet.fromMap(exerciseMap);
          exerciseIdsAddedSoFar.add(exerciseId);
        }

        Map<String, dynamic> progressionMap = (await db.query(
          'progressions',
          where: 'id = ?',
          whereArgs: [setMap['progressionId']],
        ))[0];
        set.sets
            .add(ProgressionSet.fromMap(progressionMap, reps: setMap['reps']));
        sets.add(set);
      }

      workouts.add(Workout.fromMap(workoutMap, sets: sets));
    }
    return workouts;
  }

  Future<Workout> upsertWorkout(Workout workout) async {
    if (workout.id == null) {
      workout.id = await db.insert('workouts', workout.toMap());
      for (ExerciseSet set in workout.sets) {
        await insertSets(set, workoutId: workout.id!);
      }
    } else {
      await db.update(
        'workouts',
        workout.toMap(),
        where: 'id = ?',
        whereArgs: [workout.id],
      );
      for (ExerciseSet set in workout.sets) {
        await updateSets(set, workoutId: workout.id!);
      }
    }
    return workout;
  }

  Future<bool> deleteWorkout(Workout workout) async {
    await db.delete('workouts', where: 'id = ?', whereArgs: [workout.id]);
    return true;
  }

  Future<ExerciseSet> insertSets(ExerciseSet set,
      {required int workoutId}) async {
    for (ProgressionSet pset in set.sets) {
      await db.insert('sets', pset.toMap(workoutId: workoutId));
    }
    return set;
  }

  Future<ExerciseSet> updateSets(ExerciseSet set,
      {required int workoutId}) async {
    await db.delete('sets', where: 'workoutId = ?', whereArgs: [workoutId]);
    await insertSets(set, workoutId: workoutId);
    return set;
  }

  Future<List<Exercise>> fetchExercises() async {
    List<Map<String, dynamic>> exerciseMapList = await db.query('exercises');

    List<Exercise> exercises = [];
    for (Map<String, dynamic> exerciseMap in exerciseMapList) {
      List<Map<String, dynamic>> progressionMapList = await db.query(
          'progressions',
          where: 'exerciseId = ?',
          whereArgs: [exerciseMap['id']]);
      List<Progression> progressions = progressionMapList
          .map((Map<String, dynamic> progressionMap) =>
              Progression.fromMap(progressionMap))
          .toList();

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
