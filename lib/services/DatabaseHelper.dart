import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseType.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';

class DatabaseHelper {
  late Database db;

  void _createTables(database, version) async {
    await database.execute('''
          CREATE TABLE workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT DEFAULT '',
          dateTime DATETIME DEFAULT CURRENT_TIMESTAMP
        )''');

    await database.execute('''
          CREATE TABLE exerciseTypes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL UNIQUE
        )''');

    await database.execute('''
          CREATE TABLE exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          typeId INTEGER,
          FOREIGN KEY (typeId) REFERENCES exercise_types (id)
        )''');

    await database.execute('''
          CREATE TABLE logs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          workoutId INTEGER NOT NULL,
          exerciseId INTEGER NOT NULL,
          sets INTEGER NOT NULL DEFAULT 0,
          reps INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (workoutId) REFERENCES workouts (id),
          FOREIGN KEY (exerciseId) REFERENCES exercises (id)
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

  Future<List<Workout>> fetchWorkouts({id}) async {
    final workoutsMapList = id == null
      ? await db.query('workouts')
      : await db.query(
          'workouts',
          where: 'id = ?',
          whereArgs: [id],
        );

    return workoutsMapList
      .map((workoutMap) {
        var workout = Workout.fromMap(workoutMap);
        fetchLogs(workoutId: workout.id)
          .then((logsList) => workout.logs = logsList ?? []);
        return workout;
      })
      .toList();
  }

  Future<List<Log>?> fetchLogs({id, workoutId}) async {
    final logsMapList = id != null
      ? await db.query(
          'logs',
          where: 'id = ?',
          whereArgs: [id],
        )
      : workoutId != null
        ? await db.query(
            'logs',
            where: 'workoutId = ?',
            whereArgs: [workoutId],
          )
        : await db.query('logs');

    return logsMapList
      .map((logMap) {
        var log = Log.fromMap(logMap);
        fetchExercises(id: log.exercise.id)
          .then((exercisesList) {
            if (exercisesList.length > 0) log.exercise = exercisesList.first;
          });
        return log;
      })
      .toList();
  }

  Future<List<Exercise>> fetchExercises({id, name}) async {
    final exercisesMapList = id != null
      ? await db.query(
          'exercises',
          where: 'id = ?',
          whereArgs: [id],
        )
      : name != null
        ? await db.query(
            'exercises',
            where: 'name = ?',
            whereArgs: [name],
          )
        : await db.query('exercises');

    return exercisesMapList
      .map((exerciseMap) {
        var exercise = Exercise.fromMap(exerciseMap);
        fetchExerciseTypes(id: exercise.type.id)
          .then((exerciseTypesList) {
            if (exerciseTypesList.length > 0) exercise.type = exerciseTypesList.first;
          });
        return exercise;
      })
      .toList();
  }

  Future<List<ExerciseType>> fetchExerciseTypes({id}) async {
    final exerciseTypesMapList = id == null
      ? await db.query('exerciseTypes')
      : await db.query(
          'exerciseTypes',
          where: 'id = ?',
          whereArgs: [id],
        );
    return exerciseTypesMapList
        .map((exerciseTypeMap) => ExerciseType.fromMap(exerciseTypeMap))
        .toList();
  }

  Future<Workout> insertWorkout(Workout workout) async {
    int id = await db.insert(
      'workouts',
      workout.toMap()
    );
    return fetchWorkouts(id: id).then((workouts) => workouts[0]);
  }

  Future<Workout> updateWorkout(Workout workout) async {
    await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
    return workout;
  }

  Future<void> deleteWorkout(Workout workout) async {
    await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<Exercise> insertExercise(Exercise exercise) async {
    List<Exercise> exercisesWithName = await fetchExercises(name: exercise.name);
    if (exercisesWithName.length > 0) return exercisesWithName[0];

    int id = await db.insert(
      'exercises',
      exercise.toMap()
    );
    return fetchExercises(id: id).then((exercises) => exercises[0]);
  }

  Future<Exercise> updateExercise(Exercise exercise) async {
    await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
    return exercise;
  }

  Future<void> deleteExercise(Exercise exercise) async {
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<Log> insertLog(Log log) async {
    int id = await db.insert(
      'logs',
      log.toMap()
    );
    return fetchLogs(id: id).then((logs) => logs![0]);
  }

  Future<Log> updateLog(Log log) async {
    await db.update(
      'logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
    return log;
  }

  Future<void> deleteLog(Log log) async {
    await db.delete(
      'logs',
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }
}