import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/ElementManager/delete_element_dialog.dart';
import 'package:flutter/material.dart';

class VerticalList extends StatefulWidget {
  final PageCustom page;

  const VerticalList({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateVerticalList();
}

class _StateVerticalList extends State<VerticalList> {
  PageCustom get page => widget.page;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
            flex: 5,
            child: page.elements.isNotEmpty
                ? ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) async {
                      page.reorderElements(oldIndex, newIndex);
                      setState(() {});
                    },
                    children: [
                      for (var index = 0; index < page.elements.length; index++)
                        Dismissible(
                          key: UniqueKey(),
                          child: _VerticalListElem(
                              key: UniqueKey(),
                              widget: page.elements[index].toWidget()),
                          onDismissed: (direction) async {
                            bool result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    DeleteElementDialog(
                                        elementType: page
                                            .elements[index].runtimeType
                                            .toString()));
                            if (result) {
                              await page.deleteElement(index);
                            }
                            setState(() {});
                          },
                          background: Container(color: const Color(0xBCC11717)),
                        )
                    ],
                  )
                : const Center(child: Text('No items'))),
        Expanded(child: Container()),
      ],
    );
  }
}

class _VerticalListElem extends StatelessWidget {
  final Widget widget;

  const _VerticalListElem({required Key key, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(child: widget),
    );
  }
}
