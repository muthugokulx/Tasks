import "package:tasks/models/todoModels.dart";

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todomodels> todos;
  TodoLoaded(this.todos);
}

class TodoFailure extends TodoState {
  final String message;
  TodoFailure(this.message);
}
