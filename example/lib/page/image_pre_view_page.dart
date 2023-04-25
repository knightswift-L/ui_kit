import 'package:flutter/material.dart';
import 'package:ui_kit/image/image_pre_view.dart';

class ImagePreViewPage extends StatefulWidget{
  const ImagePreViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImagePreViewPageState();
  }

}

class _ImagePreViewPageState extends State<ImagePreViewPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("图片预览"),
      ),
      body: Container(
        width: 300,
        height: 300,
        child: GestureDetector(
          onTap: (){

          },
          child: Container(
            height: 100,
            width: 100,
          ),
        )
      ),
    );
  }

}