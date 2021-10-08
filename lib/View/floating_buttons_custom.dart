import 'package:flutter/material.dart';
import '../Model/cell.dart';
import '../Model/CellComponents/book.dart';
import '../Model/Elements/text_type.dart';
import '../Model/sheet.dart';
import 'interaction_to_main_screen.dart';

class FloatingButtonsCustom extends StatelessWidget{

  final InteractionToMainScreen interMain;
  final Cell _currentCell;
  final List<Sheet> _sheets;

  const FloatingButtonsCustom(this.interMain, this._currentCell, this._sheets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  int? index = await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return StatefulBuilder(
                        builder: (context, setState){
                          /* DIALOG WITH SHEETS */
                          return SimpleDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sheets'),
                                /* BUTTON ALERT DIALOG TO ADD SHEET */
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        var _formKey = GlobalKey<FormState>();
                                        var _title = TextEditingController();
                                        var _subtitle = TextEditingController();
                                        return AlertDialog(
                                          title: const Text('Add Sheet'),
                                          scrollable: true,
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: _title,
                                                  decoration: const InputDecoration(hintText: 'Title'),
                                                  validator: (value){
                                                    if(value == null || value.isEmpty) {
                                                      return 'Please enter some text';
                                                    } else if (!interMain.isSheetTitleValid(value)) {
                                                      return 'Title already exist';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller: _subtitle,
                                                  decoration: const InputDecoration(hintText: 'Subtitle'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if(_formKey.currentState!.validate()){
                                                  await interMain.addSheet(_title.text, _subtitle.text);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Add'),
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  },
                                  icon: const Icon(Icons.add_rounded)
                                )
                              ],
                            ),
                            /* SHEETS LIST */
                            children: [
                              SizedBox(
                                width: 300,
                                height: 500,
                                child: ListView.builder(
                                  itemCount: _sheets.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return ListTile(
                                      leading: const Icon(Icons.text_snippet_rounded),
                                      title: Text(_sheets[index].title),
                                      subtitle: Text(_sheets[index].subtitle),
                                      /* DELETE SHEET */
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_forever_rounded),
                                        onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: const Text('Remove sheet'),
                                            scrollable: true,
                                            content: Text('Do you really want to delete ${_sheets[index].title} ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async{
                                                  await interMain.deleteSheet(_sheets[index].id);
                                                  Navigator.pop(context);
                                                }
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        )
                                      ),
                                      onTap: () => Navigator.pop(context, index),
                                    );
                                  },
                                ),
                              ),
                            ]
                          );
                        }
                      );
                    }
                  );
                  if(index != null){
                    await interMain.setCurrentSheet(index);
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
                              interMain.addTexts(TextType.title.index);
                            },
                            icon: const Icon(Icons.title_rounded),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              interMain.addTexts(TextType.subtitle.index);
                            },
                            icon: const Icon(Icons.title_rounded),
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: () async {
                              interMain.addTexts(TextType.text.index);
                            },
                            icon: const Icon(Icons.text_fields_rounded),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              interMain.addImage();
                            },
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                            iconSize: 45,
                          ),
                          IconButton(
                            onPressed: () async {
                              interMain.addCheckbox();
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