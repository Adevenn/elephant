import 'dart:convert';

import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Network/client.dart';

import 'quiz.dart';
import 'to_do_list.dart';
import 'book.dart';

abstract class Cell {
  final int id;
  String title;
  String subtitle;
  final String type;
  final bool multiPage;
  List<PageCustom> pages = [];
  String author;
  bool isPublic;

  Cell(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.type,
      required this.multiPage,
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

  ///Get pages that match with [id]
  Future<void> getPages() async {
    try {
      var result = await Client.requestResult('sheets', {'id_cell': id});
      pages = List<PageCustom>.from(
          result.map((model) => PageCustom.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Add page
  Future<void> addPage() async =>
      await Client.request('addPage', {'id_cell': id});

  ///Delete page
  Future<void> deletePage(int index) async =>
      await Client.deleteItem(pages[index].id, 'page');

  ///Reorder pages and update database
  Future<void> reorderPages(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    PageCustom item = pages.removeAt(oldIndex);
    pages.insert(newIndex, item);

    var jsonList = <String>[];
    for (var i = 0; i < pages.length; i++) {
      jsonList.add(jsonEncode(pages[i]));
    }
    await Client.request('updatePageOrder', {'page_order': jsonList});
  }
}
