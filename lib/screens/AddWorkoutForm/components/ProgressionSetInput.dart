import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class ProgressionSetInput extends StatelessWidget {
  ProgressionSet set;
  List<Progression> progressions;

  ProgressionSetInput({required this.set, required this.progressions});

  late TextEditingController _repsController;

  @override
  Widget build(BuildContext context) {
    _repsController = TextEditingController(text: set.reps.toString());

    if (set.id == null) set.setProgression(progressions[0]);

    return Expanded(
        child: Wrap(
          spacing: 16.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              width: 50.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _repsController,
                maxLength: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                onChanged: (v) => set.reps = int.parse(v),
                validator: (String? v) {
                  if (v == null || v.isEmpty || int.parse(v) == 0) {
                    return '';
                  }
                  return null;
                },
              ),
            ),
            Text('reps of'),
            DropdownButton<String>(
              value: set.id.toString(),
              icon: const Icon(Icons.arrow_drop_down_sharp),
              elevation: 16,
              style: const TextStyle(color: Colors.blueAccent),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? v) {
                if (v != null)
                  set.setProgression(progressions
                      .firstWhere((Progression p) => p.id == int.parse(v)));
              },
              items: progressions.map((Progression p) {
                return DropdownMenuItem(
                  value: p.id.toString(),
                  child: Text(p.name),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
