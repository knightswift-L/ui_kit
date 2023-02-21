import 'dart:math';

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
  late List<CHistogramItem> histogramItems;
  late List<CLineItem> lineItems;
  @override
  void initState() {
    super.initState();
    histogramItems = List<CHistogramItem>.generate(
      100,
          (index){
        var position = Random().nextDouble() * 1000;
        return CHistogramItem(position, "$index");
          },
    );

    lineItems = List<CLineItem>.generate(100, (index){
      return CLineItem(Random().nextDouble() * 1000, "${index % 12 + 1}月");
    });
  }

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
                          items: lineItems,
                          verticalMaxPoint: 10,
                          horizontalMaxPoint:10,
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomHistogramChartView(
                          items: histogramItems,
                          horizontalMaxCylinder: 8,
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