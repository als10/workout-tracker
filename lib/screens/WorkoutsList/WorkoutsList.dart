import 'package:date_picker_timeline/date_picker_timeline.dart' as Timeline;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:workout_tracker/models/Workout.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/AddWorkoutForm.dart';
import 'package:workout_tracker/services/DatabaseHelper.dart';

import 'components/WorkoutListItem.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  late DatabaseHelper dbHelper;
  late List<Workout> workouts;
  late DateTime selectedDate;
  Timeline.DatePickerController datePickerController = Timeline.DatePickerController();

  void _getAllWorkouts() async {
    await dbHelper.initializeDB();
    _showSnackBar(context: context, message: 'Fetching workouts...');
    workouts = await dbHelper.fetchWorkouts();
    setState(() {});
    _showSnackBar(context: context, message: 'Workouts loaded');
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    workouts = [];
    selectedDate = DateTime.now();
    _getAllWorkouts();
  }

  void _upsertWorkout(Workout workout) async {
    _showSnackBar(context: context, message: 'Adding workout...');
    Workout newWorkout = await dbHelper.upsertWorkout(workout);
    setState(() {
      workouts.remove(workout);
      workouts.add(newWorkout);
      workouts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });
    _showSnackBar(context: context, message: 'Workout added');
  }

  void _deleteWorkout(Workout workout) {
    dbHelper.deleteWorkout(workout);
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to delete this workout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    );
  }

  void _navigateToAddWorkout(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddWorkoutForm(
        upsert: _upsertWorkout,
      ),
    ));
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
    List<Map<String, dynamic>> formattedWorkouts = [];
    String prevDate = '';
    for (Workout workout in workouts) {
      String formattedDate = DateFormat('MMMM d').format(workout.dateTime).toUpperCase();
      if (prevDate == formattedDate) {
        formattedWorkouts[formattedWorkouts.length - 1]['workouts'].add(workout);
      } else {
        formattedWorkouts.add({
          'date': formattedDate,
          'workouts': [workout],
        });
        prevDate = formattedDate;
      }
    }

    if (workouts.length == 0) return Center(child: Text('No workouts yet!'));

    ItemScrollController itemScrollController = ItemScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(0, 85),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime.now();
                          datePickerController.animateToDate(DateTime.now());
                        });
                      },
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => _navigateToAddWorkout(context),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Timeline.DatePicker(
                workouts[workouts.length - 1].dateTime,
                initialSelectedDate: DateTime.now(),
                controller: datePickerController,
                selectionColor: Colors.blue,
                selectedTextColor: Colors.white,
                daysCount: (workouts[0].dateTime
                    .difference(workouts[workouts.length - 1].dateTime).inHours / 24)
                    .round() + 1,
                onDateChange: (date) {
                  setState(() {
                    int index;
                    List<DateTime> dates = [date];
                    do {
                      date = dates.removeAt(0);
                      String formattedDate = DateFormat('MMMM d').format(date).toUpperCase();
                      index = formattedWorkouts.indexWhere((m) => m['date'] == formattedDate);
                      dates.add(date.add(Duration(days: 1)));
                      dates.add(date.subtract(Duration(days: 1)));
                    } while (index == -1);
                    itemScrollController.scrollTo(
                      index: index,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutCubic
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: ScrollablePositionedList.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: formattedWorkouts.length,
        itemScrollController: itemScrollController,
        itemBuilder: (context, index) {
          Map<String, dynamic> formattedWorkout = formattedWorkouts[index];
          String date = formattedWorkout['date'];
          List<Workout> workouts = formattedWorkout['workouts'];
          return StickyHeader(
            header: Container(
              height: 50.0,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  date,
                  style: TextStyle(
                    color: Colors.black54,
                    letterSpacing: 2,
                  ),
                )
              ),
            ),
            content: Column(
              children: workouts.map((Workout workout) {
                return Dismissible(
                  confirmDismiss: (direction) => _confirmDelete(context),
                  direction: DismissDirection.endToStart,
                  key: Key(workout.id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      workouts.removeAt(index);
                    });
                    _showSnackBar(
                        context: context,
                        message: 'Deleted workout',
                        action: new SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() => workouts.insert(index, workout));
                          },
                        ),
                        handleOnDismissed: (reason) {
                          if (reason != SnackBarClosedReason.action) {
                            _deleteWorkout(workout);
                          }
                        });
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: WorkoutListItem(
                      workout: workout, updateWorkout: _upsertWorkout),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
