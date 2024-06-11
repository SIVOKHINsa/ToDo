import 'package:dartz/dartz.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

import '../../core/error/failures.dart';

class GetCategories extends UseCase<List<Category>, NoParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    try {
      final categories = await repository.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class NoParams {}