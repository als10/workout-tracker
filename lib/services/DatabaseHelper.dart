import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/models/Workout.dart';

class DatabaseHelper {
  late Database db;

  void _createTables(database, version) async {
    await database.execute('''
          CREATE TABLE workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          dateTime DATETIME DEFAULT CURRENT_TIMESTAMP
        )''');

    await database.execute('''
          CREATE TABLE exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE
        )''');

    await database.execute('''
          CREATE TABLE logs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sets INTEGER NOT NULL DEFAULT 0,
          reps INTEGER NOT NULL DEFAULT 0,
          workoutId INTEGER NOT NULL,
          exerciseId INTEGER NOT NULL,
          FOREIGN KEY (workoutId) REFERENCES workouts (id) ON DELETE CASCADE,
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
    List<Map<String, dynamic>> workoutsMapList = id == null
        ? await db.query(
            'workouts',
            orderBy: 'dateTime DESC',
          )
        : await db.query(
            'workouts',
            where: 'id = ?',
            whereArgs: [id],
          );

    List<Workout> workouts = [];
    for (Map<String, dynamic> workoutMap in workoutsMapList) {
      Workout workout = Workout.fromMap(workoutMap);
      workout.logs = await fetchLogs(workoutId: workout.id);
      workouts.add(workout);
    }
    return workouts;
  }

  Future<List<Log>> fetchLogs({id, workoutId}) async {
    List<Map<String, dynamic>> logsMapList = id != null
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

    List<Log> logs = [];
    for (Map<String, dynamic> logMap in logsMapList) {
      Log log = Log.fromMap(logMap);
      List<Exercise> exercises = await fetchExercises(id: log.exercise.id);
      log.exercise = exercises.length > 0 ? exercises[0] : Exercise();
      logs.add(log);
    }
    return logs;
  }

  Future<List<Exercise>> fetchExercises({id, name}) async {
    List<Map<String, dynamic>> exercisesMapList = id != null
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
            : await db.query(
                'exercises',
                orderBy: 'name ASC',
              );
    return exercisesMapList
        .map((Map<String, dynamic> exercise) => Exercise.fromMap(exercise))
        .toList();
  }

  Future<Workout> insertWorkout(Workout workout) async {
    int id = await db.insert('workouts', workout.toMap());
    return (await fetchWorkouts(id: id))[0];
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
    List<Exercise> exercisesWithName =
        await fetchExercises(name: exercise.name);
    if (exercisesWithName.length > 0) return exercisesWithName[0];

    int id = await db.insert('exercises', exercise.toMap());
    return (await fetchExercises(id: id))[0];
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

  Future<Log> upsertLog(Log log) async {
    List<Log> logsWithId = await fetchLogs(id: log.id);
    if (logsWithId.length > 0) {
      await db.update(
        'logs',
        log.toMap(),
        where: 'id = ?',
        whereArgs: [log.id],
      );
      return log;
    }

    int id = await db.insert('logs', log.toMap());
    return (await fetchLogs(id: id))[0];
  }

  Future<void> deleteLog(Log log) async {
    await db.delete(
      'logs',
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }
}
