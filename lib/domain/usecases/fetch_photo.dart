import 'package:dartz/dartz.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

import '../../core/error/failures.dart';

class FetchPhotos implements UseCase<List<String>, String> {
  final TaskRepository repository;

  const FetchPhotos(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(String url) async {
    try {
      final photos = await repository.fetchPhotos(url);
      return Right(photos);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}