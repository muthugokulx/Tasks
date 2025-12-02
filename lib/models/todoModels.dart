class Todomodels {
  final int userId;
  final int id;
  final String title;
  final bool isCompleted;

  Todomodels({
    required this.userId,
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todomodels.fromJson(Map<String, dynamic> json) {
    return Todomodels(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      isCompleted: json["completed"],
    );
  }
}
