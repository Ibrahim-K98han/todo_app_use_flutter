
import 'package:bloc/bloc.dart';
import 'package:todo_app/repository/todo_repository.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoLoading()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError('Todos load করা যায়নি'));
      }
    });

    on<AddTodo>((event, emit) async {
      try {
        await repository.addTodo(event.title);
        add(LoadTodos()); // reload করো
      } catch (e) {
        emit(TodoError('Todo add করা যায়নি'));
      }
    });

    on<ToggleTodo>((event, emit) async {
      try {
        await repository.toggleTodo(event.id, event.isDone);
        add(LoadTodos());
      } catch (e) {
        emit(TodoError('Update করা যায়নি'));
      }
    });

    on<DeleteTodo>((event, emit) async {
      try {
        await repository.deleteTodo(event.id);
        add(LoadTodos());
      } catch (e) {
        emit(TodoError('Delete করা যায়নি'));
      }
    });
  }
}
