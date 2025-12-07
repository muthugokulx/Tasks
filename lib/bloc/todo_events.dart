abstract class TodoEvent {}

class FetchTodos extends TodoEvent {}

class ToggleTodoStatus extends TodoEvent {
  final int index;

  ToggleTodoStatus(this.index);
}

class AddTodo extends TodoEvent {
  final String title;

  AddTodo(this.title);

  @override
  List<Object?> get props => [title];
}
