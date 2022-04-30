import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Stats.dart';
import 'package:workout_tracker/services/DatabaseHelper.dart';
import 'package:collection/collection.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage();

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DatabaseHelper dbHelper;
  final chartKey = GlobalKey<SfCartesianChartState>();

  late List<Exercise> exercises;
  late List<Progression> progressions;

  Exercise? selectedExercise;
  Progression? selectedProgression;
  Map<String, List<RepsDate>>? stats;

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
    if (exercises.length > 0) {
      selectedExercise = exercises[0];
      progressions = selectedExercise!.progressions;
      await fetchStats();
    }
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

  Future<void> fetchStats() async {
    stats = {};
    stats!['All'] = await dbHelper.fetchStats(exerciseId: selectedExercise!.id);
    for (Progression p in progressions) {
      stats![p.name] = await dbHelper.fetchStats(progressionId: p.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (exercises == null || exercises.length == 0) {
      return  Container(child: Center(child: Text('No exercises yet.')));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: DropdownButton<int>(
            value: selectedExercise!.id,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (int? v) {
              if (v != null) {
                selectedExercise =
                    exercises.firstWhere((Exercise e) => e.id == v);
                progressions = selectedExercise!.progressions;
                selectedProgression = null;
                fetchStats();
              }
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
        body: stats == null ? Container() : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Reps: ${stats!['All']!.map((e) => e.reps).sum}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Center(
                  child: SfCartesianChart(
                    backgroundColor: Colors.white,
                    legend: Legend(isVisible: true),
                    primaryXAxis: DateTimeAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      intervalType: DateTimeIntervalType.days,
                    ),
                    series: stats!.map((String pname, List<RepsDate> statList) =>
                      MapEntry(
                        pname,
                        LineSeries<RepsDate, DateTime>(
                          dataSource: statList,
                          xValueMapper: (RepsDate x, _) => x.dateTime,
                          yValueMapper: (RepsDate x, _) => x.reps,
                          name: pname,
                        )
                      )
                    ).values.toList(),
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }
  }
}
