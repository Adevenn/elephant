import '/Model/cell.dart';

class Book extends Cell{
  int sheetSelect = 0;

  Book(int id, String title, String subtitle)
      : super(id: id, title: title, subtitle: subtitle, type: (Book).toString());

  Book.fromJson(Map<String, dynamic> json)
      : super(id: json['id_cell'], title: json['title'], subtitle:
  json['subtitle'], type: (Book).toString());
}