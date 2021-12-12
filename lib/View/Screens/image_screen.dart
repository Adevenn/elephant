import 'package:flutter/material.dart';
import '/View/Elements/image_raw.dart';
import '/Model/Elements/image.dart' as Img;
import '/View/Interfaces/interaction_to_main_screen.dart';

class ImageScreen extends StatelessWidget{

  final InteractionToMainScreen interMain;
  final int idImage;

  const ImageScreen({Key? key, required this.idImage, required this.interMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Image'),
          ),
          body: FutureBuilder<Img.Image>(
            future: interMain.getRawImage(idImage),
            builder: (BuildContext context, AsyncSnapshot<Img.Image> snapshot) {
              if(snapshot.hasData){
                var image = snapshot.data!;
                return Center(
                  child: InteractiveViewer(
                    child: Container(
                      child: ImageRaw(data: image.imgRaw!),
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