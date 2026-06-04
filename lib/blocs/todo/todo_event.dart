abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class ToggleTodo extends TodoEvent {
  final int id;
  final bool isDone;
  ToggleTodo(this.id, this.isDone);
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo(this.id);
}
