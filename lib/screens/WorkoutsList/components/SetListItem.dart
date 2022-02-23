import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class SetListItem extends StatelessWidget {
  final ExerciseSet set;

  const SetListItem({required this.set});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  set.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Divider(),
                ...set.sets.asMap().map((int i, ProgressionSet pset) =>
                  MapEntry(
                    i,
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text('SET ${i+1}'),
                          Spacer(),
                          Text(pset.name),
                          Spacer(),
                          Text('${pset.reps} reps')
                        ],
                      ),
                    ),
                  )
                ).values.toList()
              ],
            ),
          ),
        ),
    );
  }
}
