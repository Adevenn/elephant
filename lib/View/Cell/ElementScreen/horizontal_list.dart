import 'package:flutter/material.dart';

import '/Model/Elements/element_custom.dart';

class HorizontalList extends StatefulWidget {
  final List<ElementCustom> elements;

  const HorizontalList({Key? key, required this.elements}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateHorizontalList();
}

class _StateHorizontalList extends State<HorizontalList> {
  List<ElementCustom> get elements => widget.elements;
  int questionIndex = 0;

  @override
  Widget build(BuildContext context) {
    print(elements[questionIndex].id);
    if (elements.isEmpty) {
      return Container();
    }
    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  questionIndex == 0 ? null : setState(() => questionIndex--);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ],
        )),
        Expanded(
            flex: 5,
            child: Center(
              child: elements[questionIndex].toWidget(),
            )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  questionIndex < elements.length - 1
                      ? setState(() => questionIndex++)
                      : null;
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded))
          ],
        )),
      ],
    );
  }
}
