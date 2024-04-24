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
    this.isCompleted = false,
    this.isFavourite = false,
    required this.createdAt,
    required this.categoryId,
  });
}