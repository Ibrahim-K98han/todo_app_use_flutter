import 'package:flutter/material.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';
import '../blocs/todo/todo_state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: Column(
        children: [
          // Input field
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'নতুন todo লেখো...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context.read<TodoBloc>().add(AddTodo(controller.text));
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          // Todo list — BlocBuilder এখানে কাজ করে
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TodoError) {
                  return Center(child: Text(state.message));
                }

                if (state is TodoLoaded) {
                  if (state.todos.isEmpty) {
                    return const Center(child: Text('কোনো todo নেই'));
                  }
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (ctx, i) {
                      final todo = state.todos[i];
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (val) {
                            context.read<TodoBloc>().add(
                              ToggleTodo(todo.id, val!),
                            );
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<TodoBloc>().add(DeleteTodo(todo.id));
                          },
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
