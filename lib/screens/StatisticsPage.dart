import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/services/DatabaseHelper.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage();

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DatabaseHelper dbHelper;
  late List<Exercise> exercises;
  Exercise? selectedExercise;

  @override
  void initState() {
    dbHelper = DatabaseHelper();
    exercises = [];
    _getAllExercises();
    super.initState();
  }

  void _getAllExercises() async {
    await dbHelper.initializeDB();
    _showSnackBar(context: context, message: 'Fetching exercises...');
    exercises = await dbHelper.fetchExercises();
    print(exercises);
    if (exercises.length > 0) selectedExercise = exercises[0];
    setState(() {});
    _showSnackBar(context: context, message: 'Exercises loaded');
  }

  void _showSnackBar(
      {required BuildContext context,
        required String message,
        SnackBarAction? action,
        Function? handleOnDismissed}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), action: action))
        .closed
        .then((reason) {
      if (handleOnDismissed != null) handleOnDismissed(reason);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedExercise == null) {
      return  Container(child: Center(child: Text('No exercises yet.')));
    } else {
      List<Progression> progressions = selectedExercise!.progressions;
      Progression selectedProgression = progressions[0];
      return Scaffold(
        appBar: AppBar(
          title: DropdownButton<int>(
            value: selectedExercise!.id,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (int? v) {
              if (v != null)
                setState(() {
                  selectedExercise = exercises.firstWhere((Exercise e) => e.id == v);
                });
            },
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            underline: Container(),
            items: exercises.map((Exercise e) {
              return DropdownMenuItem(
                value: e.id,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Progression:'),
                  SizedBox(width: 12),
                  DropdownButton<int>(
                    value: selectedProgression.id,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (int? v) {
                      if (v != null)
                        setState(() {
                          selectedProgression = progressions.firstWhere((Progression p) => p.id == v);
                        });
                    },
                    underline: Container(),
                    items: progressions.map((Progression p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name),
                      );
                    }).toList(),
                  )
                ],
              ),
            ],
          ),
        )
      );
    }
  }
}
