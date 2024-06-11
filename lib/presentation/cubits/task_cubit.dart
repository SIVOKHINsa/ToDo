import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/get_tasks.dart';
import 'package:todo/domain/usecases/update_task.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/domain/entities/task.dart' as task_entity;
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial());

  void loadTasks(String categoryId) async {
    emit(TaskLoading());
    final Either<Failure, List<task_entity.Task>> result =
        await getTasks(categoryId);
    result.fold(
      (failure) => emit(TaskError(failure.toString())),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  void addNewTask(task_entity.Task task) async {
    emit(TaskLoading());
    final Either<Failure, void> result = await addTask(task);
    result.fold(
      (failure) => emit(TaskError(failure.toString())),
      (_) => loadTasks(task.categoryId),
    );
  }

  void modifyTask(task_entity.Task task) async {
    final Either<Failure, void> result = await updateTask(task);
    result.fold(
      (failure) => emit(TaskError(failure.toString())),
      (_) async {
        final Either<Failure, List<task_entity.Task>> result =
            await getTasks(task.categoryId);
        result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (tasks) => emit(TaskLoaded(tasks)),
        );
      },
    );
  }

  void deleteTaskById(String id) async {
    final Either<Failure, void> result = await deleteTask(id);
    result.fold(
      (failure) => emit(TaskError(failure.toString())),
      (_) async {
        final categoryId = state is TaskLoaded
            ? (state as TaskLoaded)
                .tasks
                .firstWhere((task) => task.id == id)
                .categoryId
            : '';
        final Either<Failure, List<task_entity.Task>> result =
            await getTasks(categoryId);
        result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (tasks) => emit(TaskLoaded(tasks)),
        );
      },
    );
  }
}
