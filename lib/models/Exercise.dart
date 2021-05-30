class Exercise {
  int id;
  String name;

  Exercise({this.id = -1, this.name = ''});

  Exercise.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"].trim();

  Map<String, dynamic?> toMap() {
    return {
      'name': name.trim(),
    };
  }
}
