import 'package:flutter/material.dart';
import '/View/Options/option_screen.dart';
import 'add_sheet_dialog.dart';
import 'delete_sheet_dialog.dart';
import '/Model/sheet.dart';
import '../Interfaces/interaction_to_view_controller.dart';

class SheetScreen extends StatefulWidget{

  final InteractionToViewController interView;

  const SheetScreen({Key? key, required this.interView}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen>{

  InteractionToViewController get interView => widget.interView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sheets')
      ),
      endDrawer: Drawer(child: OptionScreen(interView: interView)),
      body: FutureBuilder<List<Sheet>>(
        future: interView.updateSheets(),
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
                        await interView.updateSheetsOrder(sheets);
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
                                interView.setCurrentSheetIndex(index);
                              }
                            ),
                            /* DELETE SHEET */
                            onDismissed: (direction) async{
                              bool result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context)
                                  => DeleteSheetDialog(sheetTitle: sheets[index].title)
                              );
                              if(result){
                                await interView.deleteSheet(sheets[index].id);
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
                              builder: (BuildContext context)
                                => AddSheetDialog(sheets: sheets),
                            );
                            if(list != null){
                              await interView.addSheet(list[0], list[1]);
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