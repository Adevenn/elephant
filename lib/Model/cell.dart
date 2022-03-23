import '/Model/Cells/ranking.dart';
import '/Model/Cells/to_do_list.dart';

import 'Cells/Book/book.dart';

abstract class Cell{
  final int id;
  String title;
  String subtitle;
  final String type;

  Cell({required this.id, required this.title, required this.subtitle, required this.type});

  factory Cell.factory({required int id, required String title, required String subtitle, required String type}){
    switch(type){
      case 'Book':
        return Book(id, title, subtitle);
      case 'ToDoList':
        return ToDoList(id: id, title: title);
      case 'Ranking':
        return Ranking(id: id, title: title);
      default:
        throw Exception('Factory with wrong cell type');
    }
  }

  factory Cell.fromJson(Map<String, dynamic> json){
    switch(json['type']){
      case 'Book':
        return Book.fromJson(json);
      case 'ToDoList':
        return ToDoList.fromJson(json);
      case 'Ranking':
        return Ranking.fromJson(json);
      default:
        throw Exception('Json with wrong cell type');
    }
  }

  Map<String, dynamic> toJson() => {
    'id_cell' : id,
    'title' : title,
    'subtitle' : subtitle,
    'type' : type,
  };
}