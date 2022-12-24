import 'cell.dart';

class Book extends Cell {
  Book(
      {required int id,
      required String title,
      required String subtitle,
      required String author,
      required bool isPublic})
      : super(
            id: id,
            title: title,
            subtitle: subtitle,
            type: (Book).toString(),
            multiPage: true,
            author: author,
            isPublic: isPublic);

  Book.fromJson(Map<String, dynamic> json)
      : super(
            id: json['id_cell'],
            title: json['title'],
            subtitle: json['subtitle'],
            type: (Book).toString(),
            multiPage: true,
            author: json['author'],
            isPublic: json['is_public']);
}
