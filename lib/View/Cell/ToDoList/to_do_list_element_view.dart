import 'package:flutter/material.dart';
import '/View/Cell/element_screen_template.dart';
import '/View/loading_screen.dart';
import '../../../Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';

class ToDoListElemView extends StatefulWidget {
  final InteractionToViewController interView;
  final Sheet sheet;

  const ToDoListElemView(
      {Key? key, required this.interView, required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateToDoListElemView();
}

class _StateToDoListElemView extends State<ToDoListElemView> {
  InteractionToViewController get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: interView.updateElements(sheet),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var elements = snapshot.data!;
          var widgets = interView.elementsToWidgets(elements, interView);

          return Scaffold(
            body: ElemScreenTemplate(
                interView: interView, elements: elements, widgets: widgets),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await interView.addCheckbox(sheet);
                setState(() {});
              },
              child: const Icon(Icons.add_rounded),
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
