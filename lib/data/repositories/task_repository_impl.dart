import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:drift/drift.dart';
import 'package:todo/data/database/db.dart' as db;

class TaskRepositoryImpl implements TaskRepository {
  final db.AppDatabase database;
  TaskRepositoryImpl(this.database);

  @override
  Future<List<Task>> getTasks(String categoryId) async {
    final tasks = await database.getTasksByCategoryId(categoryId);
    return tasks.map((e) => Task(
      id: e.id,
      title: e.title,
      description: e.description,
      isCompleted: e.isCompleted,
      isFavourite: e.isFavourite,
      categoryId: e.categoryId,
      createdAt: e.createdAt,
    )).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final taskCompanion = db.TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      isFavourite: Value(task.isFavourite),
      categoryId: Value(task.categoryId),
      createdAt: Value(task.createdAt),
    );
    await database.insertTask(taskCompanion);
  }

  @override
  Future<void> deleteTask(String id) async {
    await database.deleteTask(id);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskCompanion = db.TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      isFavourite: Value(task.isFavourite),
      categoryId: Value(task.categoryId),
      createdAt: Value(task.createdAt),
    );
    await database.updateTask(taskCompanion);
  }
}