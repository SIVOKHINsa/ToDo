import 'package:drift/drift.dart';
import 'package:todo/data/database/db.dart' as db;

class CategoryDataSource {
  final db.AppDatabase database;

  CategoryDataSource(this.database);

  Future<List<db.Category>> getAllCategories() async {
    return await database.getAllCategories();
  }

  Future<void> insertCategory(db.CategoriesCompanion category) async {
    await database.insertCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await database.deleteCategory(id);
  }

  Future<void> updateCategory(db.CategoriesCompanion category) async {
    await database.updateCategory(category);
  }
}