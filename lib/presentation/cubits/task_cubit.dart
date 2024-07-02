import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/get_tasks.dart';
import 'package:todo/domain/usecases/update_task.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/domain/entities/task.dart' as task_entity;
import 'task_state.dart';
import 'package:todo/domain/entities/img.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:todo/resources.dart';

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
      (tasks) => emit(TaskLoaded(tasks, [])),
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
          (tasks) => emit(TaskLoaded(tasks, [])),
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
          (tasks) => emit(TaskLoaded(tasks, [])),
        );
      },
    );
  }

  Future<void> searchPhotosFromFlickr(String query) async {
    emit(TaskLoading());
    String url = buildFlickrSearchUrl(query);

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var photos = data['photos']['photo'];
        List<String> photoUrls = photos.map<String>((photo) {
          var farmId = photo['farm'];
          var serverId = photo['server'];
          var photoId = photo['id'];
          var secret = photo['secret'];
          return 'https://farm$farmId.staticflickr.com/$serverId/${photoId}_$secret.jpg';
        }).toList();
        if (state is TaskLoaded) {
          emit(TaskLoaded((state as TaskLoaded).tasks, photoUrls));
        } else {
          emit(TaskLoaded([], photoUrls));
        }
      } else {
        emit(TaskError('Failed to search photos: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TaskError('Error searching photos: $e'));
    }
  }

  void removePhoto(int index) {
    if (state is TaskLoaded) {
      List<String> updatedPhotoUrls = List.from((state as TaskLoaded).photoUrls)..removeAt(index);
      emit(TaskLoaded((state as TaskLoaded).tasks, updatedPhotoUrls));
    }
  }

  void saveChanges(task_entity.Task task) {
    if (state is TaskLoaded) {
      List<Img> updatedImgUrls = (state as TaskLoaded).photoUrls.map((url) =>
          Img(id: const Uuid().v4(), url: url, taskId: task.id)
      ).toList();
      task.imgUrls = updatedImgUrls;
      modifyTask(task);
    }
  }

}
