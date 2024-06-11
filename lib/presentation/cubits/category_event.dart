import 'package:equatable/equatable.dart';
import 'package:todo/domain/entities/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddNewCategory extends CategoryEvent {
  final Category category;

  const AddNewCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ModifyCategoryEvent extends CategoryEvent {
  final Category category;

  const ModifyCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}