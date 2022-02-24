import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class ProgressionSetInput extends StatelessWidget {
  int index;
  ProgressionSet set;
  List<Progression> progressions;
  Function? delete;

  ProgressionSetInput({
    required this.index,
    required this.set,
    required this.progressions,
    this.delete,
  });

  late TextEditingController _repsController;

  @override
  Widget build(BuildContext context) {
    _repsController = TextEditingController(text: set.reps.toString());

    if (set.id == null) set.setProgression(progressions[0]);

    return Row(
      children: [
        Text('SET ${index+1}'),
        Spacer(),
        DropdownButton<String>(
          value: set.id.toString(),
          icon: Icon(Icons.arrow_drop_down_sharp),
          elevation: 16,
          style: TextStyle(color: Colors.blueAccent),
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
        Spacer(),
        Expanded(
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 32,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _repsController,
                  maxLength: 2,
                  onChanged: (String? v) { if (v != null) set.reps = int.parse(v); },
                  validator: (String? v) {
                    if (v == null || v.isEmpty || int.parse(v) == 0) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              Text('reps'),
              if (delete != null)
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: IconButton(
                    onPressed: delete!(),
                    icon: Icon(Icons.remove),
                  ),
                ),
            ],
          )
        ),
      ],
    );
  }
}
