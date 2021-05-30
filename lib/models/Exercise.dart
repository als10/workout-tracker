class Exercise {
  int id;
  String name;

  Exercise({
    id,
    name
  }) : this.id = id ?? -1,
       this.name = name ?? '';

  Exercise.fromMap(
    Map<String, dynamic> res
  ) : id = res["id"],
      name = res["name"].trim();

  Map<String, dynamic?> toMap() {
    return {
      'name': name.trim(),
    };
  }
}