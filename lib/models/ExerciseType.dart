class ExerciseType {
  int id;
  String type;

  ExerciseType({
    id,
    type,
  }) : this.id = id ?? -1,
       this.type = type ?? '';

  ExerciseType.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      type = res["type"];

  Map<String, Object?> toMap() {
    return {
      'type': type,
    };
  }

  // void print_() {
  //   print('Type');
  //   print('id ${id}');
  //   print('type');
  // }
}