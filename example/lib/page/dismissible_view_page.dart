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
                },
                child: Container(width: 60,color: Colors.blue,child: Text("Delete"),alignment: Alignment.center,),
              ),
              Container(width: 60,color: Colors.green,child: Text("Cancel"),alignment: Alignment.center,),
            ],child:GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>CustomChartPage()));
              },
              child: Container(width: double.infinity,height: 50, color: Colors.red,
                child: const Text("D/EGL_emulation( 4323): app_time_stats: avg=4249.76ms min=4249.76ms max=4249.76ms count=1"),
            ),),);
          },itemCount: 100,),
      )
    );
  }

}