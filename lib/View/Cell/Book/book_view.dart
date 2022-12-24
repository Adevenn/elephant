import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/Book/book_element_view.dart';
import 'package:flutter/material.dart';

typedef PageIndexCallBack = void Function(int sheetIndex);

class BookView extends StatelessWidget {
  final Cell cell;
  final int pageIndex;

  const BookView({Key? key, required this.cell, required this.pageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BookElemView(page: cell.pages[pageIndex]));
  }
}