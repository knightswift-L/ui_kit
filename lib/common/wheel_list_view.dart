import 'package:flutter/material.dart';

typedef void OnChanged(int index);

class WheelListView extends StatefulWidget {
  double width;
  double height;
  double itemHeight;
  List<String> items;
  OnChanged onChanged;
  int initialPosition;
  WheelListView(
      {Key? key,
      required this.items,
      required this.height,
      required this.width,
      required this.itemHeight,
      required this.onChanged,
      this.initialPosition = 0})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _WheelListViewState();
  }
}

class _WheelListViewState extends State<WheelListView> {
  FixedExtentScrollController? _controller;
  late List<String> items;
  @override
  void initState() {
    super.initState();
    items = widget.items;
    _controller = FixedExtentScrollController(initialItem: widget.initialPosition);
  }

  @override
  void didUpdateWidget(covariant WheelListView oldWidget) {
    items = widget.items;
    _controller = FixedExtentScrollController(initialItem: widget.initialPosition);
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
              child: ListWheelScrollView(
            controller: _controller,
            itemExtent: widget.itemHeight,
            magnification: 1.0,
            useMagnifier: true,
            physics: const FixedExtentScrollPhysics(),
            children: List<Widget>.generate(
              widget.items.length,
              (int index) => Container(
                height: widget.itemHeight,
                width: widget.width,
                color: index % 2 == 1 ? Colors.black12 : Colors.white30,
                alignment: Alignment.center,
                child: Text(
                  widget.items[index],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
          )),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: widget.itemHeight,
              width: widget.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2)),
            ),
          )
        ],
      ),
    );
  }
}
