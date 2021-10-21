import 'package:flutter/material.dart';
import '/../Model/sheet.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class SheetsScreen extends StatefulWidget{

  final InteractionToMainScreen interMain;

  const SheetsScreen({Key? key, required this.interMain}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetsScreenState();
}

class _SheetsScreenState extends State<SheetsScreen>{

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
            return Row(
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
                            onPressed: (){
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
                                        onPressed: () async {
                                          if(_formKey.currentState!.validate()){
                                            Navigator.pop(context);
                                            await interMain.addSheet(_title.text, _subtitle.text);
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
                                          Navigator.pop(context);
                                          await interMain.deleteSheet(sheets[index].id);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  )
                                )
                              ),
                              onTap: (){
                                Navigator.pop(context);
                                interMain.setCurrentSheetIndex(index);
                              }
                            );
                          }
                        )
                      ),
                    ]
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container()
                ),
              ]
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