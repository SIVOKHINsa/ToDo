import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/cubits/category_cubit.dart';
import 'package:todo/presentation/widgets/category_card.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/presentation/cubits/category_state.dart';
import 'package:todo/presentation/widgets/add_new_category_dialog.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEFU Todo App'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is LoadingCategoryState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedCategoryState) {
            final categories = state.categories;
            return categories.isNotEmpty
                ? ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onDismissed: () {
                    context
                        .read<CategoryCubit>()
                        .deleteCategoryById(category.id);
                  },
                  onEdit: (newName) {
                    final updatedCategory = Category(
                      id: category.id,
                      name: newName,
                      createdAt: category.createdAt,
                    );
                    context
                        .read<CategoryCubit>()
                        .modifyCategory(updatedCategory);
                  },
                );
              },
            )
                : const Center(child: Text('Список категорий пуст'));
          } else if (state is ErrorCategoryState) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Неизвестная ошибка'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddNewCategoryDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
