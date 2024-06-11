import 'package:todo/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskModel extends Task {
  TaskModel({
    required String title,
    String? description,
    bool isCompleted = false,
    bool isFavourite = false,
    required String categoryId,
  }) : super(
          id: const Uuid().v4(),
          title: title,
          description: description,
          isCompleted: isCompleted,
          isFavourite: isFavourite,
          categoryId: categoryId,
          createdAt: DateTime.now(),
        );
}
