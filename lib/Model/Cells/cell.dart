import 'quiz.dart';
import 'ranking.dart';
import 'to_do_list.dart';
import 'book.dart';

abstract class Cell {
  final int id;
  String title;
  String subtitle;
  final String type;
  String author;
  bool isPublic;

  Cell(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.type,
      required this.author,
      required this.isPublic});

  factory Cell.factory(
      {required int id,
      required String title,
      required String subtitle,
      required String type,
      required String author,
      required bool isPublic}) {
    switch (type) {
      case 'Book':
        return Book(
            id: id,
            title: title,
            subtitle: subtitle,
            author: author,
            isPublic: isPublic);
      case 'ToDoList':
        return ToDoList(
            id: id,
            title: title,
            subtitle: subtitle,
            author: author,
            isPublic: isPublic);
      case 'Ranking':
        return Ranking(
            id: id,
            title: title,
            subtitle: subtitle,
            author: author,
            isPublic: isPublic);
      case 'Quiz':
        return Quiz(
            id: id,
            title: title,
            subtitle: subtitle,
            type: type,
            author: author,
            isPublic: isPublic);
      default:
        throw Exception('Factory with wrong cell type');
    }
  }

  factory Cell.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Book':
        return Book.fromJson(json);
      case 'ToDoList':
        return ToDoList.fromJson(json);
      case 'Ranking':
        return Ranking.fromJson(json);
      case 'Quiz':
        return Quiz.fromJson(json);
      default:
        throw Exception('Json with wrong cell type');
    }
  }

  Map<String, dynamic> toJson() => {
        'id_cell': id,
        'title': title,
        'subtitle': subtitle,
        'type': type,
        'author': author,
        'is_public': isPublic
      };
}
