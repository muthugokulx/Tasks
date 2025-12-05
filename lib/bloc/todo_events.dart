abstract class TodoEvent {}

class FetchTodos extends TodoEvent {}

class ToggleTodoStatus extends TodoEvent {
  final int index;

  ToggleTodoStatus(this.index);
}
