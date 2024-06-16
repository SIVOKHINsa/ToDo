import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/usecases/add_category.dart';
import 'package:todo/domain/usecases/delete_category.dart';
import 'package:todo/domain/usecases/get_categories.dart';
import 'package:todo/domain/usecases/update_category.dart';
import 'package:todo/core/error/failures.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final DeleteCategory deleteCategory;
  final UpdateCategory updateCategory;

  CategoryCubit({
    required this.getCategories,
    required this.addCategory,
    required this.deleteCategory,
    required this.updateCategory,
  }) : super(InitialCategoryState());

  void loadCategories() async {
    emit(LoadingCategoryState());
    final Either<Failure, List<Category>> result = await getCategories(NoParams());
    result.fold(
          (failure) => emit(ErrorCategoryState(failure.message)),
          (categories) => emit(LoadedCategoryState(categories)),
    );
  }

  void addNewCategory(Category category) async {
    final Either<Failure, void> result = await addCategory(category);
    result.fold(
          (failure) => emit(ErrorCategoryState(failure.message)),
          (_) => loadCategories(),
    );
  }

  void deleteCategoryById(String id) async {
    final Either<Failure, void> result = await deleteCategory(id);
    result.fold(
          (failure) => emit(ErrorCategoryState(failure.message)),
          (_) => loadCategories(),
    );
  }

  void modifyCategory(Category category) async {
    final Either<Failure, void> result = await updateCategory(category);
    result.fold(
          (failure) => emit(ErrorCategoryState(failure.message)),
          (_) => loadCategories(),
    );
  }
}