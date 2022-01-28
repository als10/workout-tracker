import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class ProgressionSetInput extends StatelessWidget {
  ProgressionSet set;
  List<Progression> progressions;

  ProgressionSetInput({required this.set, required this.progressions});

  late TextEditingController _nameController;
  late TextEditingController _repsController;

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: set.name);
    _repsController = TextEditingController(text: set.reps.toString());

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100.0,
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
              value: set.name,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? v) {
                if (v != null)
                  set.setProgression(progressions.firstWhere((Progression p) => p.id == int.parse(v)));
              },
              items: progressions.map((Progression p) {
                return DropdownMenuItem(
                  value: p.id.toString(),
                  child: Text(p.name),
                );
              }).toList(),
            ),
            Container(
              width: 100.0,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                onChanged: (v) => set.name = v,
                validator: (String? v) {
                  if (v == null || v.isEmpty || int.parse(v) == 0) {
                    return '';
                  }
                  return null;
                },
              ),
            ),
          ],
        ));
  }
}
