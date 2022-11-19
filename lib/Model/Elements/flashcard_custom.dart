import 'dart:math';
import 'package:flutter/material.dart';

import '/Network/client.dart';
import 'element_custom.dart';

class FlashcardCustom extends ElementCustom {
  List<String> front, back;

  FlashcardCustom(
      {required int id,
      required int idSheet,
      required this.back,
      required this.front,
      required int idOrder})
      : super(id: id, idSheet: idSheet, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sheet': idSheet,
        'back': back,
        'front': front,
        'elem_order': idOrder,
        'elem_type': runtimeType.toString(),
      };

  @override
  Widget toWidget() {
    //var frontOrBack = Random().nextBool();

    return _FlashcardCustomView(key: UniqueKey(), flashcard: this);
  }
}

class _FlashcardCustomView extends StatelessWidget {
  final FlashcardCustom flashcard;

  const _FlashcardCustomView({Key? key, required this.flashcard})
      : super(key: key);

  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await Client.request(request, json);
    } catch (e) {
      throw Exception(e);
    }
  }

  void _updateFlashcard(List<String> newFront, List<String> newBack) {
    //if(flashcard.front.length == );
    updateItem('updateFlashcard', flashcard.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(15),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Align(
          alignment: FractionalOffset.centerRight,
          child: FloatingActionButton(
            heroTag: 'Edit',
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _FlashcardEditView(
                            front: flashcard.front,
                            back: flashcard.back,
                          )));
            },
            child: const Icon(Icons.edit_note_rounded),
          ),
        ),
        Center(child: Text('TEST ' + Random().nextInt(100).toString())),
        Tooltip(
          message: 'Check answer',
          child: FloatingActionButton(
            heroTag: 'Check',
            onPressed: () {},
            child: const Icon(Icons.check),
          ),
        )
      ]),
    ));
  }
}

class _FlashcardEditView extends StatelessWidget {
  final List<String> front;
  final List<String> back;

  const _FlashcardEditView({Key? key, required this.front, required this.back})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Flashcard')),
      body: Column(
        children: const [
          Center(child: Text('Front side :')),
          //ReorderableListView(children: children, onReorder: onReorder),
          Center(child: Text('Back side :')),
          ListTile(),
        ],
      ),
    );
  }
}
