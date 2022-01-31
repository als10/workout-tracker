class Exercise {
  int? id;
  String name;
  List<Progression> progressions;

  Exercise({this.id, required this.name, List<Progression>? progressions})
      : this.progressions = progressions ?? [];

  Exercise.empty({String? name, List<Progression>? progressions})
      : this.name = name ?? '',
        this.progressions = progressions ?? [Progression.empty()];

  Exercise.fromMap(Map<String, dynamic> map, {List<Progression>? progressions})
      : this(
            id: map["id"],
            name: map["name"].trim(),
            progressions: progressions);

  Map<String, dynamic> toMap() {
    return {
      "name": this.name.trim(),
    };
  }

  void updateRanks() {
    this.progressions = this.progressions.asMap()
      .map((int index, Progression p) {
        p.rank = index;
        return MapEntry(index, p);
      }).values.toList();
  }
}

class Progression {
  int? id;
  int exerciseId;
  int rank;
  String name;

  Progression(
      {this.id,
      required this.exerciseId,
      required this.rank,
      required this.name});

  Progression.empty({int? exerciseId, int? rank, String? name})
      : this.exerciseId = exerciseId ?? -1,
        this.rank = rank ?? -1,
        this.name = name ?? '';

  Progression.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            exerciseId: map["exerciseId"],
            rank: map["rank"],
            name: map["name"].trim());

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': this.exerciseId,
      'name': this.name.trim(),
      'rank': this.rank,
    };
  }
}
