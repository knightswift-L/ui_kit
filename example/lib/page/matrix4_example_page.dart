import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Matrix4ExamplePage extends StatefulWidget {
  const Matrix4ExamplePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Matrix4ExamplePageState();
  }
}

class _Matrix4ExamplePageState extends State<Matrix4ExamplePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double width = MediaQueryData.fromWindow(window).size.width;
  double threshold = MediaQueryData.fromWindow(window).size.width * 0.3;
  double distance = -1;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animationController.addListener(updateAnimation);
    animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          distance = -1;
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.completed:
          break;
      }
    });
  }

  updateAnimation() {
    setState(() {
      distance = threshold * animationController.value;
      print(animationController.value);
      print(distance);
    });
  }

  @override
  void dispose() {
    animationController.removeListener(updateAnimation);
    animationController.dispose();
    super.dispose();
  }

  //HorizontalDragGestureRecognizer
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          if (details.globalPosition.dx < width * 0.25 && distance != threshold) {
            distance = 0;
          }
          },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (distance >= 0 && distance <= threshold) {
            var temp = distance + details.delta.dx;
            if (temp < 0) {
              distance = 0;
            } else if (temp > threshold) {
              distance = threshold;
            } else {
              distance = temp;
            }
            setState(() {});
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (distance < 0 || distance >= threshold) {
            return;
          }

          if (distance < threshold / 2) {
            animationController.reverse(from: distance / threshold);
          } else {
            animationController.forward(from: distance / threshold);
          }
        },
        child: SizedBox(
          width: MediaQueryData.fromWindow(window).size.width,
          height: MediaQueryData.fromWindow(window).size.height,
          child: Stack(
            children: [
              Transform(
                transform:
                    Matrix4.rotationY(-pi / 2 * (1 - distance / threshold)),
                alignment: Alignment.centerLeft,
                child: Container(
                    width: MediaQueryData.fromWindow(window).size.width * 0.7,
                    height: double.infinity,
                    color: Colors.blue,
                    child:SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [IntrinsicHeight(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 50,
                                    backgroundImage:Image.network("https://w.wallhaven.cc/full/1p/wallhaven-1pd1o9.jpg",width:200,height:200,fit: BoxFit.cover,).image
                                ),
                                SizedBox(width: 10,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 10,),
                                    Text("Knight Swift",style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(height: 10,),
                                    Text("knightswift@163.com"),
                                  ],
                                ))
                              ],
                            ),
                          )],
                        ),
                      ),
                    )),
              ),
              Transform.translate(
                offset: Offset(distance * 0.5, 0),
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.rotationY(distance <= 0 ? 0 :acos((width - width * 0.7 * sin(pi / 2 * (distance / threshold))+distance * 0.5) / width)),
                  child: Container(
                      color: Colors.green.withOpacity(0.5),
                      width: MediaQueryData.fromWindow(window).size.width,
                      height: double.infinity,
                      child: Column(
                        children: [
                          Image.network("https://w.wallhaven.cc/full/1p/wallhaven-1pd1o9.jpg",fit: BoxFit.fitWidth,width: 100,),
                          Image.network("https://w.wallhaven.cc/full/1p/wallhaven-1pd1o9.jpg",fit: BoxFit.fitWidth,),
                          const Text("knightswift@163.com"),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
