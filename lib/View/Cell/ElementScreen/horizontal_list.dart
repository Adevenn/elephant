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
    return Column(
      children: [
        Expanded(child: Container()),
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      questionIndex == 0
                          ? null
                          : setState(() => questionIndex--);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Container(child: elements[questionIndex].toWidget()),
                IconButton(
                    onPressed: () {
                      questionIndex <= elements.length
                          ? null
                          : setState(() => questionIndex++);
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            )),
        Expanded(child: Container()),
      ],
    );
  }
}
