import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final List<Category> _categories = [];

  @override
  Future<List<Category>> getCategories() async {
    return _categories;
  }

  @override
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((category) => category.id == id);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }
}