import 'package:uuid/uuid.dart';

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

class Category {
  String id;
  String name;
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class DataModel {
  List<Category> categories = [];
  Map<String, List<Task>> tasksByCategory = {};

  void addCategory(String categoryName) {
    String categoryId = Uuid().v4();
    Category newCategory = Category(id: categoryId,
        name: categoryName,
      createdAt: DateTime.now(),);
    categories.add(newCategory);
    tasksByCategory[categoryId] = [];
  }

  void addTaskToCategory(String categoryId, String taskTitle) {
    Task newTask = Task(
      id: Uuid().v4(),
      title: taskTitle,
      description: '',
      isCompleted: false,
      isFavourite: false,
      createdAt: DateTime.now(),
      categoryId: categoryId,
    );
    tasksByCategory[categoryId]?.add(newTask);
  }

  void deleteCategory(String categoryId) {
    categories.removeWhere((category) => category.id == categoryId);
    tasksByCategory.remove(categoryId);
  }

  void updateCategoryName(Category category, String newName) {
    Category updatedCategory = categories.firstWhere((c) => c.id == category.id);
    if (updatedCategory != null) {
      updatedCategory.name = newName;
    }
  }

  void deleteTask(String categoryId, String taskId) {
    tasksByCategory[categoryId]?.removeWhere((task) => task.id == taskId);
  }

  void updateTask(Task task, String newTitle, String newDescription, bool newIsCompleted, bool newIsFavourite) {
    Task? updatedTask = tasksByCategory[task.categoryId]?.firstWhere((t) => t.id == task.id);
    if (updatedTask != null) {
      updatedTask.title = newTitle;
      updatedTask.description = newDescription;
      updatedTask.isCompleted = newIsCompleted;
      updatedTask.isFavourite = newIsFavourite;
    }
  }
}

final dataModel = DataModel();