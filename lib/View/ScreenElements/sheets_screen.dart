import 'package:flutter/material.dart';
import '../../Model/sheet.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class SheetsScreen extends StatefulWidget{

  final InteractionToMainScreen interMain;
  final List<Sheet> sheets;

  const SheetsScreen({Key? key, required this.interMain, required this.sheets}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetsScreenState();
}

class _SheetsScreenState extends State<SheetsScreen>{

  InteractionToMainScreen get interMain => widget.interMain;
  late List<Sheet> sheets = widget.sheets;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    sheets = interMain.getSheets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sheets')
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container()
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sheets'),
                    /* BUTTON ALERT DIALOG TO ADD SHEET */
                    IconButton(
                      onPressed: () async{
                        await showDialog(
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
                                      setState(() {});
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
                SizedBox(
                  width: 300,
                  height: 500,
                  child: ListView.builder(
                    itemCount: sheets.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        leading: const Icon(Icons.text_snippet_rounded),
                        title: Text(sheets[index].title),
                        subtitle: Text(sheets[index].subtitle),
                        /* DELETE SHEET */
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever_rounded),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Remove sheet'),
                              scrollable: true,
                              content: Text('Do you really want to delete ${sheets[index].title} ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async{
                                    await interMain.deleteSheet(sheets[index].id);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            )
                          )
                        ),
                        onTap: () => Navigator.pop(context, index),
                      );
                    },
                  ),
                ),
              ]
            ),
          ),
          Expanded(
            flex: 2,
            child: Container()
          ),
        ]
      )
    );
  }
}