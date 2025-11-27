class Berry {
  final int id;
  final String name;
  final int growthTime;

  Berry({required this.id, required this.name, required this.growthTime});

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      id: json['id'],
      name: json['name'],
      growthTime: json['growth_time'],
    );
  }
}
