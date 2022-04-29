import 'package:flutter/material.dart';
import 'package:workout_tracker/screens/HomePage.dart';
import 'package:workout_tracker/screens/WorkoutsList/WorkoutsList.dart';

void main() {
  runApp(MaterialApp(
    title: 'Workouts',
    home: HomePage(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black45),
        elevation: 0,
      )
    ),
    initialRoute: '/',
  ));
}
