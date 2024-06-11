import 'package:todo/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks(String categoryId);
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
}