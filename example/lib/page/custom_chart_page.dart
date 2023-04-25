import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/toast.dart';
import 'package:ui_kit/ui_kit.dart';

class CustomChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomChartPage();
  }
}

class _CustomChartPage extends State<CustomChartPage> {
  late List<CHistogramItem> histogramItems;
  late List<CLineItem> lineItems;
  @override
  void initState() {
    super.initState();
    histogramItems = List<CHistogramItem>.generate(
      100,
      (index) {
        var position = Random().nextDouble() * 1000;
        return CHistogramItem(position, "$index");
      },
    );

    lineItems = List<CLineItem>.generate(100, (index) {
      return CLineItem(Random().nextDouble() * 30, "${index % 12 + 1}月");
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
                height: 200,
                // width: 200,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomLineChartView(
                          key: UniqueKey(),
                          items: lineItems,
                          verticalMaxPoint: 5,
                          horizontalMaxPoint: 10,
                          labelInterval: 20,
                          hasDotOnPointOfJunction: true,
                          selectedLabelBuilder: (key, value) {
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
                          labelInterval: 5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: CustomPieChartView(
                  items: [
                    CPieItem(100, "食品", Colors.red),
                    CPieItem(1000, "衣服", Colors.blue),
                    CPieItem(2000, "电子产品", Colors.green),
                    CPieItem(300, "其他", Colors.pink),
                  ],
                ),
              ),
              CustomRadarView(
                width: 400,
                height: 400,
                level: 5,
                items: [
                  CustomRadarItem(title: "A", value: 5, key: "A"),
                  CustomRadarItem(title: "B", value: 5, key: "B"),
                  CustomRadarItem(title: "C", value: 5, key: "C"),
                  CustomRadarItem(title: "D", value: 5, key: "D"),
                  CustomRadarItem(title: "E", value: 5, key: "E"),
                  CustomRadarItem(title: "F", value: 5, key: "F"),
                  CustomRadarItem(title: "G", value: 5, key: "G"),
                  CustomRadarItem(title: "H", value: 5, key: "H"),
                  CustomRadarItem(title: "I", value: 5, key: "I"),
                  CustomRadarItem(title: "J", value: 5, key: "J")
                ],
                maps: [
                  CustomRadarGroup(title: "03-10", maps: {
                    "A": CustomRadarItem(title: "A", value: 5, key: "A"),
                    "B": CustomRadarItem(title: "A", value: 1, key: "B"),
                    "C": CustomRadarItem(title: "A", value: 5, key: "C"),
                    "D": CustomRadarItem(title: "A", value: 3, key: "D"),
                    "E": CustomRadarItem(title: "A", value: 5, key: "E"),
                    "F": CustomRadarItem(title: "A", value: 2, key: "F"),
                    "G": CustomRadarItem(title: "A", value: 5, key: "G"),
                    "H": CustomRadarItem(title: "A", value: 4, key: "H"),
                    "I": CustomRadarItem(title: "A", value: 5, key: "I"),
                    "J": CustomRadarItem(title: "A", value: 0, key: "J")
                  }, color: Colors.blue),
                  CustomRadarGroup(title: "03-11", maps: {
                    "A": CustomRadarItem(title: "A", value: 2, key: "A"),
                    "B": CustomRadarItem(title: "A", value: 1, key: "B"),
                    "C": CustomRadarItem(title: "A", value: 4, key: "C"),
                    "D": CustomRadarItem(title: "A", value: 3, key: "D"),
                    "E": CustomRadarItem(title: "A", value: 3, key: "E"),
                    "F": CustomRadarItem(title: "A", value: 5, key: "F"),
                    "G": CustomRadarItem(title: "A", value: 1, key: "G"),
                    "H": CustomRadarItem(title: "A", value: 3, key: "H"),
                    "I": CustomRadarItem(title: "A", value: 2, key: "I"),
                    "J": CustomRadarItem(title: "A", value: 4, key: "J")
                  }, color: Colors.redAccent),
                  CustomRadarGroup(title: "03-12", maps: {
                    "A": CustomRadarItem(title: "A", value: 1, key: "A"),
                    "B": CustomRadarItem(title: "A", value: 1, key: "B"),
                    "C": CustomRadarItem(title: "A", value: 4, key: "C"),
                    "D": CustomRadarItem(title: "A", value: 5, key: "D"),
                    "E": CustomRadarItem(title: "A", value: 2, key: "E"),
                    "F": CustomRadarItem(title: "A", value: 2, key: "F"),
                    "G": CustomRadarItem(title: "A", value: 5, key: "G"),
                    "H": CustomRadarItem(title: "A", value: 1, key: "H"),
                    "I": CustomRadarItem(title: "A", value: 4, key: "I"),
                    "J": CustomRadarItem(title: "A", value: 1, key: "J")
                  }, color: Colors.orange),
                  CustomRadarGroup(title: "03-13", maps: {
                    "A": CustomRadarItem(title: "A", value: 3, key: "A"),
                    "B": CustomRadarItem(title: "A", value: 1, key: "B"),
                    "C": CustomRadarItem(title: "A", value: 5, key: "C"),
                    "D": CustomRadarItem(title: "A", value: 0, key: "D"),
                    "E": CustomRadarItem(title: "A", value: 1, key: "E"),
                    "F": CustomRadarItem(title: "A", value: 5, key: "F"),
                    "G": CustomRadarItem(title: "A", value: 4, key: "G"),
                    "H": CustomRadarItem(title: "A", value: 1, key: "H"),
                    "I": CustomRadarItem(title: "A", value: 2, key: "I"),
                    "J": CustomRadarItem(title: "A", value: 3, key: "J")
                  }, color: Colors.purple),


                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
