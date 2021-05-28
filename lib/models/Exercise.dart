import 'package:workout_tracker/models/ExerciseType.dart';

class Exercise {
  int id;
  String name;
  ExerciseType type;

  Exercise({
    id,
    name,
    type,
  }) : this.id = id ?? -1,
       this.name = name ?? '',
       this.type = type ?? ExerciseType();

  Exercise.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      name = res["name"],
      type = ExerciseType(id: res["typeId"]);

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'typeId': type.id == -1 ? null : type.id
    };
  }

  // void print_() {
  //   print('Exercise');
  //   print('id ${id}');
  //   print('name ${name}');
  //   print('type');
  //   type.print_();
  // }
}