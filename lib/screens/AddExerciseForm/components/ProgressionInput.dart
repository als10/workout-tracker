import 'package:flutter/material.dart';
import 'package:workout_tracker/models/Exercise.dart';

class ProgressionInputs extends StatefulWidget {
  List<Progression> progressions;
  ProgressionInputs({required this.progressions});

  @override
  _ProgressionInputsState createState() => _ProgressionInputsState();
}

class _ProgressionInputsState extends State<ProgressionInputs> {
  @override
  Widget build(BuildContext context) {
    List<Progression> progressions = widget.progressions;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'PROGRESSIONS',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ReorderableListView(
                shrinkWrap: true,
                children: progressions.map((Progression p) =>
                  ProgressionInput(
                      key: Key(p.rank.toString()),
                      initialValue: p.name,
                      onChange: (v) => p.name = v,
                      deleteProgression: progressions.length > 1
                          ? () => setState(() => progressions.remove(p))
                          : null,
                    )).toList(),
                onReorder: (int start, int current) {
                  int i = start;
                  Progression changedProgression = progressions[start];
                  if (start < current) {
                    while (i < current) progressions[i] = progressions[++i];
                  }
                  else if (start > current) {
                    while (i > current) progressions[i] = progressions[--i];
                  }
                  progressions[current] = changedProgression;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ProgressionInput extends StatelessWidget {
  final String initialValue;
  final Function onChange;
  final Function? deleteProgression;

  ProgressionInput(
      {Key? key, this.initialValue = '', required this.onChange, this.deleteProgression})
  : super(key: key);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.menu),
          SizedBox(width: 16),
          Expanded(
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
                  return 'Please enter the progression name';
                }
                return null;
              },
            ),
          ),
          if (deleteProgression != null)
            IconButton(
              icon: Icon(Icons.highlight_remove, color: Colors.black45),
              onPressed: () => deleteProgression!(),
            ),
        ],
      ),
    );
  }
}
