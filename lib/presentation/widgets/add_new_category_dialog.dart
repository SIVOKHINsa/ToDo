import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/cubits/category_cubit.dart';

class AddNewCategoryDialog extends StatelessWidget {
  const AddNewCategoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return AlertDialog(
      title: const Text('Добавить категорию'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Название категории',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty) {
              final newCategory = Category(
                id: const Uuid().v4(),
                name: name,
                createdAt: DateTime.now(),
              );
              context.read<CategoryCubit>().addNewCategory(newCategory);
            }
            Navigator.pop(context);
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
