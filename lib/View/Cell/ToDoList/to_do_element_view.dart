import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/ElementScreen/vertical_list.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class ToDoElemView extends StatefulWidget {
  final PageCustom page;

  const ToDoElemView({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateToDoListElemView();
}

class _StateToDoListElemView extends State<ToDoElemView> {
  PageCustom get page => widget.page;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: page.getElements(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const LoadingScreen();
          case ConnectionState.active:
          case ConnectionState.done:
            return Scaffold(
                body: VerticalList(page: page),
                floatingActionButton: FloatingButtons(
                  page: page,
                  elementsType: const ['checkbox'],
                  onElementAdded: () {
                    setState(() {});
                  },
                ));
        }
      },
    );
  }
}
