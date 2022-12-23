import 'package:elephant_client/Model/Elements/element_custom.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<ElementCustom> elements;

  const HorizontalList({Key? key, required this.elements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return PageView.builder(
      controller: controller,
      itemCount: elements.length,
      itemBuilder: (context, index) {
        return elements[index].toWidget();
      },
    );
  }
}
