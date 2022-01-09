import 'package:flutter/material.dart';
import '/Model/CellComponents/book.dart';
import '/Model/Elements/text_type.dart';
import '/View/Sheet/sheet_screen.dart';
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
        bottomSheet: Container(
          margin: const EdgeInsets.all(15),
          child: Tooltip(
            message: 'Sheets',
            child: FloatingActionButton(
              heroTag: 'sheetsBtn',
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SheetScreen(interView: interView))
                );
                print('Sheet closed');
                //setState(() {});
              },
              child: const Icon(Icons.text_snippet),
            ),
          ),
        ),
        endDrawer: Drawer(child: OptionScreen(interView: interView)),
        body: ItemsScreen(key: UniqueKey(), interView: interView),
        floatingActionButton: floatingBtn()
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

  ExpandableFab floatingBtn(){
    return ExpandableFab(
        distance: 150.0,
        children: [
          IconButton(
            onPressed: () async {
              await interView.addTexts(TextType.title.index);
              setState(() {});
            },
            icon: const Icon(Icons.title_rounded),
            iconSize: 45,
          ),
          IconButton(
            onPressed: () async {
              await interView.addTexts(TextType.subtitle.index);
              setState(() {});
            },
            icon: const Icon(Icons.title_rounded),
            iconSize: 40,
          ),
          IconButton(
            onPressed: () async {
              await interView.addTexts(TextType.text.index);
              setState(() {});
            },
            icon: const Icon(Icons.text_fields_rounded),
            iconSize: 45,
          ),
          IconButton(
            onPressed: () async {
              //TODO: If cancel => no setState
              await interView.addImage();
              setState(() {});
            },
            icon: const Icon(Icons.add_photo_alternate_outlined),
            iconSize: 45,
          ),
          IconButton(
            onPressed: () async {
              await interView.addCheckbox();
              setState(() {});
            },
            icon: const Icon(Icons.check_box_rounded),
            iconSize: 45,
          ),
        ]
    );
  }
}