import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:ui_kit_example/page/custom_chart_page.dart';

class DismissibleViewPage extends StatefulWidget{
  const DismissibleViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DismissibleViewPageState();
  }

}
class _DismissibleViewPageState extends State<DismissibleViewPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DismissibleViewPage"),),
      body: DismissibleViewManager(
        child: ListView.builder(
          controller: ScrollController(),
          itemBuilder: (BuildContext context,int index){
            return DismissibleView(actionView: [
              GestureDetector(
                onTap: (){
                  print("Delete");
                },
                child: Container(width: 60,color: Colors.blue,child: Text("Delete"),alignment: Alignment.center,),
              ),
              Container(width: 60,color: Colors.green,child: Text("Cancel"),alignment: Alignment.center,),
            ],child:GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>CustomChartPage()));
              },
              child: Container(width: double.infinity,height: 50, color: Colors.white,
                child: const Text("I'm a dismissible View"),
            ),),);
          },itemCount: 100,),
      )
    );
  }

}