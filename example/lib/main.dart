import 'package:flutter/material.dart';
import 'package:ui_kit/toast.dart';
import 'package:ui_kit_example/page/home_page.dart';
void main() {
  runApp(CustomApp());
}



class CustomApp extends StatelessWidget{
  const CustomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom App Exercise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (BuildContext context){
        Toast().init(context);
        return HomePage();
      },),
    );
  }

}

