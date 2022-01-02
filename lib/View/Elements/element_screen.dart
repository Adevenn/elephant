import 'package:flutter/material.dart';
import '/Model/cell.dart';

import 'items_screen.dart';
import 'floating_buttons.dart';
import '../Interfaces/interaction_to_view_controller.dart';
import '../Options/option_screen.dart';

class ElementScreen extends StatefulWidget{
  final InteractionToViewController _interView;
  final Cell _cell;

  const ElementScreen(this._interView, this._cell, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementState();
}

class _ElementState extends State<ElementScreen>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InteractionToViewController get interView => widget._interView;
  Cell get cell => widget._cell;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar(),
        endDrawer: Drawer(child: OptionScreen(interView: interView)),
        body: ItemsScreen(key: UniqueKey(), interView: interView),
        floatingActionButton: FloatingButtons(interView, cell)
      )
    );
  }

  AppBar appBar(){
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(cell.title),
    );
  }
}