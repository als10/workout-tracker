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
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'EXERCISE',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                controller: _controller,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => onChange(v),
                validator: (String? v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
