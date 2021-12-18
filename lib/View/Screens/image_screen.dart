import 'dart:typed_data';

import 'package:flutter/material.dart';
import '/View/Elements/image_raw.dart';
import '/Model/Elements/image.dart' as img;
import '/View/Interfaces/interaction_main_screen.dart';

class ImageScreen extends StatelessWidget{

  final InteractionMainScreen interMain;
  final int idImage;

  const ImageScreen({Key? key, required this.idImage, required this.interMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Image'),
          ),
          body: FutureBuilder<Uint8List>(
            future: interMain.selectRawImage(idImage),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if(snapshot.hasData){
                print('DATA ARRIVED !!');
                var data = snapshot.data!;
                return Center(
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 1.6,
                    child: Container(
                      child: ImageRaw(data: data),
                    ),
                  ),
                );
              }
              else {
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
            },
          ),
        )
    );
  }

}