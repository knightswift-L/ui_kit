import 'package:flutter/material.dart';
import 'package:ui_kit/toast.dart';
import 'package:ui_kit/ui_kit.dart';

class CustomChartPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CustomChartPage();
  }

}

class _CustomChartPage extends State<CustomChartPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Chart"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomLineChartView(
                          key: UniqueKey(),
                          items: List<CLineItem>.generate(100, (index) => CLineItem((index % 10).toDouble() + 10, "${index % 12 + 1}月")),
                          verticalMaxPoint: 10,
                          horizontalMaxPoint:30,
                          hasDotOnPointOfJunction:true,
                          selectedLabelBuilder: (key,value){
                            return "$key  $value";
                          },
                          selectedColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomHistogramChartView(
                          items: List<CHistogramItem>.generate(
                            100,
                                (index) => CHistogramItem(index % 10.toDouble() + 10, "$index"),
                          ),
                          horizontalMaxCylinder: 20,
                          verticalMaxScale: 10,
                          labelInterval:5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 200,
                child: CustomPieChartView(
                  items: [
                    CPieItem(100, "食品", Colors.red),
                    CPieItem(1000, "衣服", Colors.blue),
                    CPieItem(2000, "电子产品", Colors.green),
                    CPieItem(300, "其他", Colors.pink),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}