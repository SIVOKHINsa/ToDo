class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  bool isFavourite;
  DateTime createdAt;
  String categoryId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isFavourite,
    required this.createdAt,
    required this.categoryId,
  });
}