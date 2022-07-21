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
    if (elements.isEmpty) {
      return Container();
    }
    return Row(
      children: [
        Expanded(child: () {
          if (questionIndex == 0) {
            return Container();
          }
          return IconButton(
              onPressed: () => setState(() => questionIndex--),
              icon: const Icon(Icons.arrow_back_ios_new_rounded));
        }()),
        Expanded(
            flex: 5,
            child: Center(
              child: elements[questionIndex].toWidget(),
            )),
        Expanded(child: () {
          if (questionIndex >= elements.length - 1) {
            return Container();
          }
          return IconButton(
              onPressed: () => setState(() => questionIndex++),
              icon: const Icon(Icons.arrow_forward_ios_rounded));
        }()),
      ],
    );
  }
}
