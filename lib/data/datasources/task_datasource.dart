import 'package:drift/drift.dart';
import 'package:todo/data/database/db.dart' as db;

class TaskDataSource {
  final db.AppDatabase database;

  TaskDataSource(this.database);

  Future<List<db.Task>> getTasksByCategoryId(String categoryId) async {
    return await (database.select(database.tasks)..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }

  Future<List<db.Img>> getImgsByTaskId(String taskId) async {
    return await (database.select(database.imgs)..where((tbl) => tbl.taskId.equals(taskId))).get();
  }

  Future<void> insertTask(db.TasksCompanion task) async {
    await database.into(database.tasks).insert(task);
  }

  Future<void> insertImg(db.ImgsCompanion img) async {
    await database.into(database.imgs).insert(img);
  }

  Future<void> addImgToTask(String taskId, List<db.ImgsCompanion> imgs) async {
    for (var img in imgs) {
      await insertImg(img.copyWith(taskId: Value(taskId)));
    }
  }

  Future<void> deleteTask(String id) async {
    await (database.delete(database.tasks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteImgsByTaskId(String taskId) async {
    await (database.delete(database.imgs)..where((tbl) => tbl.taskId.equals(taskId))).go();
  }

  Future<void> updateTask(db.TasksCompanion task) async {
    await (database.update(database.tasks)..where((tbl) => tbl.id.equals(task.id.value))).write(task);
  }
}