import '../cell.dart';

class ToDoList extends Cell {
  ToDoList({required int id, required String title, String subtitle = ''})
      : super(
            id: id,
            title: title,
            subtitle: subtitle,
            type: (ToDoList).toString());

  ToDoList.fromJson(Map<String, dynamic> json)
      : super(
            id: json['id'],
            title: json['title'],
            subtitle: json['subtitle'],
            type: (ToDoList).toString());
}
