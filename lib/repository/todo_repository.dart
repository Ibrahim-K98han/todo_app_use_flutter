import '../models/todo.dart';
import '../services/api_service.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async {
    final data = await ApiService.getTodos();
    return data.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> addTodo(String title) => ApiService.addTodo(title);
  Future<void> toggleTodo(int id, bool isDone) =>
      ApiService.toggleTodo(id, isDone);
  Future<void> deleteTodo(int id) => ApiService.deleteTodo(id);
}
