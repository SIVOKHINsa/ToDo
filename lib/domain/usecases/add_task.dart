import 'package:dartz/dartz.dart';
import 'package:todo/domain/entities/task.dart' as task_entity;
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

import '../../core/error/failures.dart';

class AddTask implements UseCase<void, task_entity.Task> {
  final TaskRepository repository;

  const AddTask(this.repository);

  @override
  Future<Either<Failure, void>> call(task_entity.Task task) async {
    try {
      await repository.addTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}