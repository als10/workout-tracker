import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class ProgressionSetInput extends StatelessWidget {
  ProgressionSet set;
  ProgressionSetInput({required this.set});

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
            Container(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _nameController,
                maxLength: 2,
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
