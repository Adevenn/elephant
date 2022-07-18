import 'cell.dart';

class Quiz extends Cell {
  Quiz(
      {required int id,
      required String title,
      required String subtitle,
      required String type,
      required String author,
      required bool isPublic})
      : super(
            id: id,
            title: title,
            subtitle: subtitle,
            type: type,
            author: author,
            isPublic: isPublic);

  Quiz.fromJson(Map<String, dynamic> json)
      : super(
            id: json['id_cell'],
            title: json['title'],
            subtitle: json['subtitle'],
            type: (Quiz).toString(),
            author: json['author'],
            isPublic: json['is_public']);
}
