import 'package:flutter/material.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'blocs/todo/todo_bloc.dart';
import 'blocs/todo/todo_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: BlocProvider(
        create: (_) => TodoBloc(TodoRepository())..add(LoadTodos()),
        child: const TodoScreen(),
      ),
    );
  }
}
