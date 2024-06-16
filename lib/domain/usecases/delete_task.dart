import 'package:dartz/dartz.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

import '../../core/error/failures.dart';

class DeleteTask implements UseCase<void, String> {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      await repository.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}