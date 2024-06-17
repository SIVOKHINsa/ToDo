import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'category_db.dart';
import 'task_db.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Categories, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<void> insertCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<void> updateCategory(CategoriesCompanion category) => update(categories).replace(category);
  Future<void> deleteCategory(String id) => (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<List<Task>> getTasksByCategoryId(String categoryId) =>
      (select(tasks)..where((t) => t.categoryId.equals(categoryId))).get();
  Future<void> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future<void> updateTask(TasksCompanion task) => update(tasks).replace(task);
  Future<void> deleteTask(String id) => (delete(tasks)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}