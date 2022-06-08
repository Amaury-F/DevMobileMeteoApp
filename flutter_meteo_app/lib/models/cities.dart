class Cities {
  final String name;

  Cities(this.name);

  Cities.fromMap(Map<String, dynamic> res) : name = res["name"];

  Map<String, Object?> toMap() {
    return {
      'name': name,
    };
  }
}
