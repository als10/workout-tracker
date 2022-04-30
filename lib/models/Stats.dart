import 'package:intl/intl.dart';

class RepsDate {
  int reps;
  DateTime dateTime;

  RepsDate({required this.reps, required this.dateTime});

  RepsDate.fromMap(Map<String, dynamic> res)
    : this(
      reps: res['reps'],
      dateTime: DateFormat('dd-MM-yyyy').parse(res['dateTime']),
    );
}