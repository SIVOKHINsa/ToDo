import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:drift/drift.dart';
import 'package:todo/data/database/db.dart' as db;
import 'package:todo/data/datasources/category_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<List<Category>> getCategories() async {
    final categories = await dataSource.getAllCategories();
    return categories.map((e) => Category(
      id: e.id,
      name: e.name,
      createdAt: e.createdAt,
    )).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    final categoryCompanion = db.CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      createdAt: Value(category.createdAt),
    );
    await dataSource.insertCategory(categoryCompanion);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await dataSource.deleteCategory(id);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryCompanion = db.CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      createdAt: Value(category.createdAt),
    );
    await dataSource.updateCategory(categoryCompanion);
  }
}