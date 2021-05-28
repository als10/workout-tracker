import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetsAndRepsInput extends StatelessWidget {
  final TextEditingController setsController;
  final TextEditingController repsController;
  final Function onSetsChange;
  final Function onRepsChange;

  SetsAndRepsInput({
    required this.setsController,
    required this.repsController,
    required this.onSetsChange,
    required this.onRepsChange
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: setsController,
                maxLength: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                onChanged: (v) => onSetsChange(v),
              ),
            ),
            Text('sets of'),
            Container(
              width: 100.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: repsController,
                maxLength: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                onChanged: (v) => onRepsChange(v),
              ),
            ),
            Text('reps'),
          ],
        )
    );
  }
}