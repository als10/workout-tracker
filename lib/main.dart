import 'package:flutter/material.dart';
import 'package:workout_tracker/screens/WorkoutsList/WorkoutsList.dart';
import 'package:workout_tracker/routes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Workouts',
    home: WorkoutsList(),
    initialRoute: '/',
    onGenerateRoute: CustomRouter.generateRoute,
  ));
}