import 'package:flutter/material.dart';

typedef void OnChanged(int index);

class WheelListView extends StatefulWidget {
  double width;
  double height;
  double itemHeight;
  List<String> items;
  OnChanged onChanged;
  int initialPosition;
  WheelListView({Key? key, required this.items, required this.height, required this.width, required this.itemHeight, required this.onChanged, this.initialPosition = 0}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _WheelListViewState();
  }
}

class _WheelListViewState extends State<WheelListView> {
  ScrollController? _controller;
  double _endScrollLocation = 0;
  bool hasStartScroll = false;
  bool hasEndScroll = true;
  int lastLocation = 0;
  late List<String> items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = widget.items;
    lastLocation = widget.initialPosition;
    _controller = ScrollController(initialScrollOffset: widget.initialPosition * widget.itemHeight);
  }

  @override
  void didUpdateWidget(covariant WheelListView oldWidget) {
    items = widget.items;
    lastLocation = 0;
    _controller = ScrollController(initialScrollOffset: 0);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned.fill(
              child: NotificationListener<ScrollNotification>(
            child: ListWheelScrollView(
              controller: _controller,
              itemExtent: widget.itemHeight,
              children: List<Widget>.generate(
                widget.items.length,
                (int index) => Container(
                  height: widget.itemHeight,
                  width: widget.width,
                  color: index % 2 == 1 ? Colors.black12 : Colors.white30,
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.items[index]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification && hasEndScroll) {
                hasStartScroll = true;
                hasEndScroll = false;
              }

              if (notification is ScrollEndNotification && hasStartScroll) {
                hasStartScroll = false;
                hasEndScroll = true;
                _endScrollLocation = notification.metrics.pixels;
                int target = 0;
                if (_endScrollLocation % widget.itemHeight > widget.itemHeight / 2) {
                  _controller!.jumpTo(_endScrollLocation + (widget.itemHeight - _endScrollLocation % widget.itemHeight));
                  if (_endScrollLocation ~/ widget.itemHeight != widget.items.length) {
                    target = _endScrollLocation ~/ widget.itemHeight;
                  } else {
                    target = _endScrollLocation ~/ widget.itemHeight + 1;
                  }
                } else {
                  _controller!.jumpTo(_endScrollLocation - (_endScrollLocation % widget.itemHeight));

                  target = _endScrollLocation ~/ widget.itemHeight;
                }
                if (target != lastLocation) {
                  lastLocation = target;
                  widget.onChanged(target);
                }
              }
              return true;
            },
          )),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: widget.itemHeight,
              width: widget.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
            ),
          )
        ],
      ),
    );
  }
}
