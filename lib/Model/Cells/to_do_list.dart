import '../cell.dart';

class ToDoList extends Cell {
  ToDoList(
      {required int id,
      required String title,
      String subtitle = '',
      required String author,
      required bool isPublic})
      : super(
            id: id,
            title: title,
            subtitle: subtitle,
            type: (ToDoList).toString(),
            author: author,
            isPublic: isPublic);

  ToDoList.fromJson(Map<String, dynamic> json)
      : super(
            id: json['id_cell'],
            title: json['title'],
            subtitle: json['subtitle'],
            type: (ToDoList).toString(),
            author: json['author'],
            isPublic: json['is_public']);
}
