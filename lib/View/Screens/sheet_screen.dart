import 'package:flutter/material.dart';
import '/Model/sheet.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class SheetScreen extends StatefulWidget{

  final InteractionToMainScreen interMain;

  const SheetScreen({Key? key, required this.interMain}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen>{

  InteractionToMainScreen get interMain => widget.interMain;

  bool isSheetTitleValid(List<Sheet> sheets, String title){
    for(int i = 0; i < sheets.length; i++){
      if(sheets[i].title == title){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sheets')
      ),
      body: FutureBuilder<List<Sheet>>(
        future: interMain.updateSheets(),
        builder: (BuildContext context, AsyncSnapshot<List<Sheet>> snapshot) {
          if (snapshot.hasData) {
            var sheets = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  /* SHEETS LIST */
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) async{
                        if (oldIndex < newIndex){
                          newIndex -= 1;
                        }
                        Sheet item = sheets.removeAt(oldIndex);
                        sheets.insert(newIndex, item);
                        await interMain.updateSheetsOrder(sheets);
                        setState(() {});
                      },
                      children: [
                        for(var index = 0; index < sheets.length; index++)
                          Dismissible(
                            key: UniqueKey(),
                            background: Container(color: const Color(0xBCC11717)),
                            child: ListTile(
                              leading: const Icon(Icons.text_snippet_rounded),
                              title: Text(sheets[index].title),
                              subtitle: Text(sheets[index].subtitle),
                              onTap: (){
                                Navigator.pop(context);
                                interMain.setCurrentSheetIndex(index);
                              }
                            ),
                            /* DELETE SHEET */
                            onDismissed: (direction) async{
                              bool result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Remove sheet'),
                                  content: Text('Do you really want to delete ${sheets[index].title} ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                )
                              );
                              if(result){
                                await interMain.deleteSheet(sheets[index].id);
                              }
                              setState(() {});
                            }
                          )
                      ],
                    ),
                  ),
                  /* ADD SHEET */
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.add_rounded),
                          title: const Text('Add sheet'),
                          onTap: () async{
                            var list = await showDialog<List<String>?>(
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
                                            } else if (!isSheetTitleValid(sheets, value)) {
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
                                      onPressed: (){
                                        if(_formKey.currentState!.validate()){
                                          List<String> sheet = [_title.text, _subtitle.text];
                                          Navigator.pop(context, sheet);
                                        }
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              }
                            );
                            if(list != null){
                              await interMain.addSheet(list[0], list[1]);
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                  )
                ]
              ),
            );
          }
          else if(snapshot.hasError){
            throw Exception('');
          }
          else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting ...'),
                  )
                ],
              ),
            );
          }
        }
      ),
    );
  }
}