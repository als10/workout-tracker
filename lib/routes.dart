import 'package:flutter/material.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AddWorkoutForm.routeName:
        ScreenArguments screenArgs = args as ScreenArguments;
        return MaterialPageRoute(builder: (_) =>
          AddWorkoutForm(
            upsert: screenArgs.upsertWorkout,
            workout: screenArgs.workout,
          )
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No route defined for ${settings.name}')),
            )
        );
    }
  }
}