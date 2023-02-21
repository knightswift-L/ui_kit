import 'dart:async';

import 'package:flutter/material.dart';

class ImagePreView extends StatefulWidget {
  const ImagePreView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImagePreViewState();
  }
}

class _ImagePreViewState extends State<ImagePreView> {
  late StreamController<Matrix4> streamController;
  @override
  void initState() {
    streamController = StreamController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: StreamBuilder(
        stream: streamController.stream,
        initialData: Matrix4(
          1,0,0,0,
          0,1,0,0,
          0,0,1,0,
          0,0,0,1,
        ),
        builder: (BuildContext context, AsyncSnapshot<Matrix4> snapshot) {
          return Image.network("https://w.wallhaven.cc/full/6o/wallhaven-6oxgp6.jpg",fit: BoxFit.fitWidth,width: 300,);
          if(snapshot.hasError || !snapshot.hasData){
            return SizedBox(
              width: 300,
              height: 300,
              child: Image.network("https://w.wallhaven.cc/full/6o/wallhaven-6oxgp6.jpg",fit: BoxFit.fitWidth,width: 300,),
            );
          }
          return Transform(
              transform: snapshot.data!,
              child: Image.network("https://w.wallhaven.cc/full/6o/wallhaven-6oxgp6.jpg",fit: BoxFit.fitWidth,
              width: 300,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? chunkEvent){
                if(chunkEvent == null) {
                  return Container();
                }
                return Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: chunkEvent.cumulativeBytesLoaded/(chunkEvent.expectedTotalBytes ?? 1),
                    ),
                  ),
                );
              },
              ),
          );
        },
      ),
    );
  }
}
