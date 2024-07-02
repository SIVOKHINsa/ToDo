import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/entities/img.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:drift/drift.dart';
import 'package:todo/data/database/db.dart' as db;
import 'package:todo/data/datasources/task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<Task>> getTasks(String categoryId) async {
    final tasks = await dataSource.getTasksByCategoryId(categoryId);
    List<Task> taskList = [];
    for (var task in tasks) {
      List<Img> imgs = await dataSource.getImgsByTaskId(task.id);
      taskList.add(Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        isFavourite: task.isFavourite,
        categoryId: task.categoryId,
        createdAt: task.createdAt,
        imgUrls: imgs,
      ));
    }

    return taskList;
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
    await dataSource.insertTask(taskCompanion);
  }

  @override
  Future<void> deleteTask(String id) async {
    await dataSource.deleteImgsByTaskId(id);
    await dataSource.deleteTask(id);
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
    await dataSource.updateTask(taskCompanion);
    await dataSource.deleteImgsByTaskId(task.id);
    await dataSource.addImgToTask(task.id, task.imgUrls.map((img) =>
        db.ImgsCompanion(imgUrl: Value(img.url))).toList());
  }
}