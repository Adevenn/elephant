import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/View/Cell/Book/book_floating_btn.dart';

class RankView extends StatelessWidget {
  final InteractionToViewController interView;

  const RankView({Key? key, required this.interView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: BookFloatingBtn(interView: interView),
    );
  }
}
