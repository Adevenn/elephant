import 'package:flutter/material.dart';
import 'sheets_screen.dart';
import '../../Model/cell.dart';
import '../../Model/CellComponents/book.dart';
import '../../Model/Elements/text_type.dart';
import '../../Model/sheet.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class FloatingButtonsCustom extends StatelessWidget{
  final InteractionToMainScreen interMain;
  final Cell _currentCell;
  final List<Sheet> _sheets;

  const FloatingButtonsCustom(this.interMain, this._currentCell, this._sheets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* SHEETS MANAGER */
        if(_currentCell.runtimeType == Book)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Tooltip(
              message: 'Sheets',
              child: FloatingActionButton(
                heroTag: 'sheetsBtn',
                onPressed: () async {
                  int? index = await Navigator.push(context, MaterialPageRoute(builder: (context) => SheetsScreen(interMain: interMain, sheets: _sheets)));
                  if(index != null){
                    interMain.setCurrentSheet(index);
                  }
                },
                child: const Icon(Icons.text_snippet),
              ),
            ),
          ),
        /* ADD ELEMENTS */
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: FloatingActionButton(
            heroTag: 'addElementBtn',
            child: const Icon(Icons.add_rounded),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(30),
                    height: 300,
                    child: Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 60,
                        children: [
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await interMain.addTexts(TextType.title.index);
                            },
                            icon: const Icon(Icons.title_rounded),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await interMain.addTexts(TextType.subtitle.index);
                            },
                            icon: const Icon(Icons.title_rounded),
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await interMain.addTexts(TextType.text.index);
                            },
                            icon: const Icon(Icons.text_fields_rounded),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await interMain.addImage();
                            },
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await interMain.addCheckbox();
                            },
                            icon: const Icon(Icons.check_box_rounded),
                            iconSize: 45,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}