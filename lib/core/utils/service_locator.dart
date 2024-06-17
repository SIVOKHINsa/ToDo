import 'package:get_it/get_it.dart';
import 'package:todo/data/repositories/category_repository_impl.dart';
import 'package:todo/data/repositories/task_repository_impl.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/add_category.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_category.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/get_categories.dart';
import 'package:todo/domain/usecases/get_tasks.dart';
import 'package:todo/domain/usecases/update_category.dart';
import 'package:todo/domain/usecases/update_task.dart';
import 'package:todo/presentation/cubits/category_cubit.dart';
import 'package:todo/presentation/cubits/task_cubit.dart';
import 'package:todo/data/database/db.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));


  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));

  sl.registerFactory(() => CategoryCubit(
    getCategories: sl(),
    addCategory: sl(),
    deleteCategory: sl(),
    updateCategory: sl(),
  ));

  sl.registerFactory(() => TaskCubit(
    getTasks: sl(),
    addTask: sl(),
    updateTask: sl(),
    deleteTask: sl(),
  ));
}