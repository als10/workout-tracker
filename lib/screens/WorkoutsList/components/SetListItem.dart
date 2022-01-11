import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class SetListItem extends StatelessWidget {
  final ExerciseSet set;

  const SetListItem({required this.set});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(set.name,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Column(
              children: set.sets.map((ProgressionSet pset) {
                return Text(
                  '${pset.name}: ${pset.reps.toString()} reps',
                  style: Theme.of(context).textTheme.bodyText2,
                );
              }).toList(),
            ),
          ],
        ));
  }
}
