import 'package:equatable/equatable.dart';
import 'package:todo/domain/entities/category.dart';


abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}


class InitialCategoryState extends CategoryState {
  const InitialCategoryState();

  @override
  List<Object?> get props => [];
}


class LoadingCategoryState extends CategoryState {
  const LoadingCategoryState();

  @override
  List<Object?> get props => [];
}


class LoadedCategoryState extends CategoryState {
  final List<Category> categories;

  const LoadedCategoryState(this.categories);

  @override
  List<Object?> get props => [categories];
}


class ErrorCategoryState extends CategoryState {
  final String message;

  const ErrorCategoryState(this.message);

  @override
  List<Object?> get props => [message];
}

