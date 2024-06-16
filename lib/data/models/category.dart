import 'package:todo/domain/entities/category.dart';
import 'package:uuid/uuid.dart';

class CategoryModel extends Category {
  CategoryModel({required String name})
      : super(
          id: const Uuid().v4(),
          name: name,
          createdAt: DateTime.now(),
        );
}
