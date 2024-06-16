class Task {
  final String id;
  String title;
  String? description;
  bool isCompleted;
  bool isFavourite;
  final String categoryId;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.isFavourite,
    required this.categoryId,
    required this.createdAt,
  });

  void update({required String title, String? description}) {
    this.title = title;
    this.description = description;
  }
}
