import 'package:equatable/equatable.dart';
import 'package:todo/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<String> photoUrls;

  const TaskLoaded(this.tasks, this.photoUrls);

  @override
  List<Object> get props => [tasks, photoUrls];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
