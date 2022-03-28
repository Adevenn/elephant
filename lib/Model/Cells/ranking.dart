import '../cell.dart';

class Ranking extends Cell {
  Ranking(
      {required int id,
      required String title,
      String subtitle = '',
      required String author,
      required bool isPublic})
      : super(
            id: id,
            title: title,
            subtitle: subtitle,
            type: (Ranking).toString(),
            author: author,
            isPublic: isPublic);

  Ranking.fromJson(Map<String, dynamic> json)
      : super(
            id: json['id_cell'],
            title: json['title'],
            subtitle: json['subtitle'],
            type: (Ranking).toString(),
            author: json['author'],
            isPublic: json['is_public']);
}
