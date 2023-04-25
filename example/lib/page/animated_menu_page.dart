import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AnimatedMenuPage extends StatefulWidget {
  const AnimatedMenuPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedMenuPageState();
  }
}

class _AnimatedMenuPageState extends State<AnimatedMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ExamplePage"),
      ),
      body: Center(
        child: AnimatedMenuView(
          layout: Layout.around,
          actionChild: [
            Container(
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.black,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.green,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.black,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.green,
            )
          ],
          radius: 100,
          child: Container(
            width: 30,
            height: 30,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}