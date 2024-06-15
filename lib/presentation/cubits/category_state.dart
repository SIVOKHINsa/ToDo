import 'package:equatable/equatable.dart';
import 'package:todo/domain/entities/category.dart';

class CategoryStatus extends Equatable {
  final String value;

  const CategoryStatus._(this.value);

  static const CategoryStatus initial = CategoryStatus._('initial');
  static const CategoryStatus loading = CategoryStatus._('loading');
  static const CategoryStatus loaded = CategoryStatus._('loaded');
  static const CategoryStatus error = CategoryStatus._('error');

  @override
  List<Object?> get props => [value];
}

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<Category> categories;
  final String message;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.message = '',
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<Category>? categories,
    String? message,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message ?? this.message,
    );
  }

  static CategoryState initial() {
    return const CategoryState(status: CategoryStatus.initial);
  }

  static CategoryState loading() {
    return const CategoryState(status: CategoryStatus.loading);
  }

  static CategoryState loaded(List<Category> categories) {
    return CategoryState(status: CategoryStatus.loaded, categories: categories);
  }

  static CategoryState error(String message) {
    return CategoryState(status: CategoryStatus.error, message: message);
  }

  @override
  List<Object?> get props => [status, categories, message];
}
