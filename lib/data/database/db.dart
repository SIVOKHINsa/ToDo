import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'category_db.dart';
import 'task_db.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Categories, Tasks, Imgs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.createTable(imgs);
      }
    },
  );

  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<void> insertCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<void> updateCategory(CategoriesCompanion category) => update(categories).replace(category);
  Future<void> deleteCategory(String id) => (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<List<Task>> getTasksByCategoryId(String categoryId) =>
      (select(tasks)..where((t) => t.categoryId.equals(categoryId))).get();
  Future<void> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future<void> updateTask(TasksCompanion task) => update(tasks).replace(task);
  Future<void> deleteTask(String id) => (delete(tasks)..where((t) => t.id.equals(id))).go();


  Future<List<Img>> getImgsByTaskId(String taskId) async {
    return await (select(imgs)..where((i) => i.taskId.equals(taskId))).get();
  }
  Future<void> insertImg(ImgsCompanion img) => into(imgs).insert(img);
  Future<void> deleteImgsByTaskId(String taskId) =>
      (delete(imgs)..where((i) => i.taskId.equals(taskId))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}