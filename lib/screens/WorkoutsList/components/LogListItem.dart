import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Log.dart';

class LogListItem extends StatelessWidget {
  final Log log;

  const LogListItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(log.exercise.name,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Text(
              '${log.sets.toString()} sets of ${log.reps.toString()} reps',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ));
  }
}
