import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseNameInput extends StatelessWidget {
  final String initialValue;
  final Function onChange;

  ExerciseNameInput({this.initialValue = '', required this.onChange});

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.bodyText2,
          labelText: 'Exercise Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        onChanged: (v) => onChange(v),
        validator: (String? v) {
          if (v == null || v.isEmpty) {
            return 'Please enter the exercise name';
          }
          return null;
        },
      ),
    );
  }
}
