class Todo {
  final int id;
  final String title;
  final bool isDone;

  Todo({required this.id, required this.title, required this.isDone});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    isDone: json['is_done'] == true || json['is_done'] == 1,
  );
}
