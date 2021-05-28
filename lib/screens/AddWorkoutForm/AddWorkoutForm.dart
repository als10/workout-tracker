import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/Log.dart';
import 'package:workout_tracker/screens/AddWorkoutForm/components/LogInputs.dart';

class AddWorkoutForm extends StatefulWidget {
  static const routeName = '/AddWorkoutForm';

  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  static Log defaultLog = Log(
    exercise: Exercise(name: ''),
    sets: 0,
    reps: 0,
  );
  static List<Log> logsList = [defaultLog];

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  void _save(context) {
    final Function addWorkout = ModalRoute.of(context)!.settings.arguments as Function;
    addWorkout(logs: logsList);
    Navigator.of(context).pop();
    logsList = [defaultLog];
  }

  List<Widget> _getExercises() {
    List<Widget> logsInputFieldsList = [];
    print(logsList);
    for(int i = 0; i < logsList.length; i++) {
      logsInputFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              LogInputs(logsList, i),
              if (logsList.length > 1)
                ElevatedButton(
                onPressed: () {
                  logsList.removeAt(i);
                  setState((){});
                },
                child: Text('Remove exercise'),
              ),
            ],
          ),
        ),
      );
    }
    return logsInputFieldsList;
  }

  // Widget exerciseNameInput(controller, context, index) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  //     child: TextField(
  //       controller: controller,
  //       style: Theme
  //           .of(context)
  //           .textTheme
  //           .bodyText2,
  //       decoration: InputDecoration(
  //         labelStyle: Theme
  //             .of(context)
  //             .textTheme
  //             .bodyText2,
  //         labelText: 'Exercise Name',
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(0.0),
  //         ),
  //       ),
  //       onChanged: (v) => logsList[index].exercise!.name = v,
  //     ),
  //   );
  // }

  // Widget setsAndRepsInput(_setsController, _repsController, context, index) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //           width: 100.0,
  //           child: TextField(
  //             keyboardType: TextInputType.number,
  //             controller: _setsController,
  //             maxLength: 2,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0.0),
  //               ),
  //             ),
  //             onChanged: (v) => logsList[index].sets = int.parse(v),
  //           ),
  //         ),
  //         Text('sets of'),
  //         Container(
  //           width: 100.0,
  //           child: TextField(
  //             keyboardType: TextInputType.number,
  //             controller: _repsController,
  //             maxLength: 2,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0.0),
  //               ),
  //             ),
  //             onChanged: (v) => logsList[index].reps = int.parse(v),
  //           ),
  //         ),
  //         Text('reps'),
  //       ],
  //     )
  //   );
  // }

  Widget exerciseInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getExercises(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                logsList.add(defaultLog);
                setState((){});
              },
              child: Text('Add another exercise'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Name'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => _save(context),)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: exerciseInput(),
        ),
      ),
    );
  }
}