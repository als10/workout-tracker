import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracker/models/Exercise.dart';
import 'package:workout_tracker/models/ExerciseSet.dart';

class ProgressionSetInput extends StatefulWidget {
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

  @override
  State<ProgressionSetInput> createState() => _ProgressionSetInputState();
}

class _ProgressionSetInputState extends State<ProgressionSetInput> {
  late TextEditingController _repsController;

  @override
  Widget build(BuildContext context) {
    ProgressionSet set = widget.set;
    List<Progression> progressions = widget.progressions;
    _repsController = TextEditingController(text: set.reps.toString());

    if (set.id == null) set.setProgression(progressions[0]);

    return Row(
      children: [
        Text('SET ${widget.index + 1}'),
        Spacer(),
        DropdownButton<String>(
          value: set.id.toString(),
          icon: Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: TextStyle(color: Colors.blueAccent),
          onChanged: (String? v) {
            if (v != null)
              setState(() {
                set.setProgression(progressions
                    .firstWhere((Progression p) => p.id == int.parse(v)));
              });
          },
          items: progressions.map((Progression p) {
            return DropdownMenuItem(
              value: p.id.toString(),
              child: Text(p.name),
            );
          }).toList(),
        ),
        Spacer(),
        SizedBox(
          width: 32,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _repsController,
            inputFormatters: [LengthLimitingTextInputFormatter(2)],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(6),
              border: OutlineInputBorder(),
            ),
            onChanged: (String? v) { if (v != null) set.reps = int.parse(v); },
            validator: (String? v) {
              if (v == null || v.isEmpty || int.parse(v) == 0) {
                return '';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 4),
        Text('reps'),
        if (widget.delete != null)
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: IconButton(
              onPressed: () => widget.delete!(),
              icon: Icon(Icons.highlight_remove),
            ),
          ),
      ],
    );
  }
}

