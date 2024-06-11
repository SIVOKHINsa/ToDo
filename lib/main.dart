import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/utils/service_locator.dart';
import 'package:todo/presentation/screens/categories_screen.dart';
import 'package:todo/presentation/cubits/category_cubit.dart';
import 'package:todo/presentation/cubits/task_cubit.dart';
import 'package:get_it/get_it.dart';

void main() {
  init();
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (context) => GetIt.I<CategoryCubit>()..loadCategories(),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => GetIt.I<TaskCubit>(),
        ),
      ],
      child: const MaterialApp(
        home: CategoriesScreen(),
      ),
    );
  }
}