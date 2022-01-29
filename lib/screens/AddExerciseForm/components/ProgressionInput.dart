import 'package:flutter/material.dart';

class ProgressionInput extends StatelessWidget {
  final String initialValue;
  final Function onChange;
  final Function? deleteProgression;

  ProgressionInput(
      {this.initialValue = '', required this.onChange, this.deleteProgression});

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextFormField(
              controller: _controller,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyText2,
                labelText: 'Progression Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onChanged: (v) => onChange(v),
              validator: (String? v) {
                if (v == null || v.isEmpty) {
                  return 'Please enter the progression name';
                }
                return null;
              },
            ),
          ),
          if (deleteProgression != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteProgression!(),
            ),
        ],
      ),
    );
  }
}
