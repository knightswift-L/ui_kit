part of ui_kit;

class CLineItem {
  double value;
  String key;
  CLineItem(this.value, this.key);
}

class _CLinePoint {
  double px;
  double py;
  _CLinePoint(this.px, this.py);
}

typedef String SelectedLabelBuilder(String key, double value);
typedef void MaxScrollDistance(double distance);

class CustomLineChartView extends StatefulWidget {
  final List<CLineItem> items;
  final Color scaleLineColor;
  final Color scaleTextColor;
  final Color backgroundColor;
  final Color lineColor;
  final int horizontalMaxPoint;
  final int verticalMaxPoint;
  final int labelInterval;
  final bool hasDotOnPointOfJunction;
  final Color selectedColor;
  final SelectedLabelBuilder? selectedLabelBuilder;
  CustomLineChartView({Key? key, required this.items, this.scaleLineColor = Colors.white, this.scaleTextColor = Colors.white, this.backgroundColor = Colors.blue, this.selectedColor = Colors.blue, this.lineColor = Colors.white, this.horizontalMaxPoint = 20, this.verticalMaxPoint = 5, this.labelInterval = 5, this.hasDotOnPointOfJunction = false, this.selectedLabelBuilder}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CustomLineChartViewState();
  }
}

class _CustomLineChartViewState extends State<CustomLineChartView> {
  double scrollX = double.infinity;
  double maxDistance = 0;
  late StreamController<_Notification> _listener;
  double startX = 0;
  _Notification notification = _Notification();

  @override
  void initState() {
    super.initState();
    _listener = StreamController<_Notification>();
  }

  @override
  dispose() {
    _listener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (DragDownDetails details) {
        startX = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        var current = details.localPosition.dx;
        if (scrollX + (startX - current) > maxDistance) {
          scrollX = maxDistance;
        } else if (scrollX + (startX - current) < 0) {
          scrollX = 0;
        } else {
          scrollX = scrollX + (startX - current);
        }
        notification.scrollX = scrollX;
        _listener.add(notification);
        startX = current;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        startX = 0;
      },
      onLongPressStart: (LongPressStartDetails details) {
        notification.scrollX = scrollX;
        notification.selected = details.localPosition.dx;
        _listener.add(notification);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        notification.selected = -1;
        _listener.add(notification);
      },
      child: StreamBuilder(
        stream: _listener.stream,
        builder: (BuildContext context, AsyncSnapshot<_Notification> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: _LineChartPainter(
                  key: UniqueKey(),
                  items: widget.items,
                  horizontalMaxPoint: widget.horizontalMaxPoint,
                  verticalMaxPoint: widget.verticalMaxPoint,
                  scrollX: snapshot.data!.scrollX,
                  selectedLocation: snapshot.data!.selected,
                  scaleTextColor: widget.scaleTextColor,
                  scaleLineColor: widget.scaleLineColor,
                  backgroundColor: widget.backgroundColor,
                  lineColor: widget.lineColor,
                  labelInterval: widget.labelInterval,
                  hasDotOnPointOfJunction: widget.hasDotOnPointOfJunction,
                  selectedColor: widget.selectedColor,
                  selectedLabelBuilder: widget.selectedLabelBuilder,
                  maxScrollDistance: (distance) {
                    if (scrollX > distance && widget.items.length > 0) {
                      scrollX = distance;
                    }
                    maxDistance = distance;
                  },
                ),
              ),
            );
          }
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(
                key: UniqueKey(),
                items: widget.items,
                horizontalMaxPoint: widget.horizontalMaxPoint,
                verticalMaxPoint: widget.verticalMaxPoint,
                scrollX: double.infinity,
                scaleTextColor: widget.scaleTextColor,
                scaleLineColor: widget.scaleLineColor,
                backgroundColor: widget.backgroundColor,
                lineColor: widget.lineColor,
                labelInterval: widget.labelInterval,
                hasDotOnPointOfJunction: widget.hasDotOnPointOfJunction,
                selectedColor: widget.selectedColor,
                selectedLabelBuilder: widget.selectedLabelBuilder,
                maxScrollDistance: (distance) {
                  if (scrollX > distance && widget.items != null && widget.items.length > 0) {
                    scrollX = distance;
                  }
                  maxDistance = distance;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Notification {
  double scrollX = double.infinity;
  double selected = -1;
  bool isRepaint = false;
}

class _LineChartPainter extends CustomPainter {
  List<_CLinePoint> points = [];
  int start = 0;
  Key? key;
  final List<CLineItem> items;
  final int horizontalMaxPoint;
  final int verticalMaxPoint;
  final int labelInterval;
  final bool hasDotOnPointOfJunction;
  final double scrollX;
  final Color scaleTextColor;
  final Color scaleLineColor;
  final Color backgroundColor;
  final Color lineColor;
  final Color selectedColor;
  final double selectedLocation;
  int? _selectedPosition;
  final SelectedLabelBuilder? selectedLabelBuilder;
  final MaxScrollDistance maxScrollDistance;
  double availableWidth = 0.0;
  double availableHeight = 0.0;
  final double marginLeft = 50;
  final double marginTop = 20;
  final double marginBottom = 20;
  final double marginRight = 20;
  _LineChartPainter({
    Key? key,
    required this.items,
    required this.horizontalMaxPoint,
    required this.verticalMaxPoint,
    required this.scrollX,
    required this.scaleTextColor,
    required this.scaleLineColor,
    required this.backgroundColor,
    required this.lineColor,
    required this.labelInterval,
    required this.hasDotOnPointOfJunction,
    this.selectedLocation = -1,
    required this.selectedColor,
    this.selectedLabelBuilder,
    required this.maxScrollDistance,
  });
  double maxY = 0;
  double distance = 0;
  calculatePoints(Size size) {
    availableHeight = size.height - marginTop - marginBottom;
    availableWidth = size.width - marginLeft - marginRight;
    distance = availableWidth / (horizontalMaxPoint - 1);
    double _maxScrollDistance = items.length <= horizontalMaxPoint ? 0 : (distance * (items.length - 1)) - availableWidth;
    maxScrollDistance(_maxScrollDistance);
    if (scrollX >= _maxScrollDistance) {
      start = items.length <= horizontalMaxPoint ? 0 : items.length - horizontalMaxPoint;
    } else {
      start = (scrollX / distance).floor().toInt();
    }
    var maxValue = 0.0;
    for (var position = start; position < start + horizontalMaxPoint && position < items.length; position++) {
      maxValue = maxValue > items[position].value ? maxValue : items[position].value;
    }

    maxY = maxValue * 1.2;
    points.clear();
    for (var position = 0; position < horizontalMaxPoint && position < items.length; position++) {
      points.add(_CLinePoint(distance * position + marginLeft, marginTop + availableHeight * (1 - (items[position + start].value / maxY))));
    }

    if (selectedLocation == -1) {
      _selectedPosition = null;
    } else {
      var _selectedLocation = selectedLocation - marginLeft;
      _selectedPosition = _selectedLocation % distance > distance / 2 ? (_selectedLocation / distance).ceil() : (_selectedLocation / distance).floor();
    }
  }

  drawBorder(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1;
    paint.color = scaleLineColor;
    canvas.drawLine(Offset(marginLeft, size.height - marginBottom), Offset(size.width - marginRight, size.height - marginBottom), paint);
    canvas.drawLine(Offset(marginLeft, marginTop), Offset(marginLeft, size.height - marginBottom), paint);
  }

  drawScale(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1;
    for (var position = 0; position <= verticalMaxPoint; position++) {
      var positionY = availableHeight / verticalMaxPoint * position + marginTop;
      paint.color = scaleLineColor;
      canvas.drawLine(Offset(marginLeft, positionY), Offset(marginLeft + 5, positionY), paint);
      TextPainter tp = getTextPainter((maxY / verticalMaxPoint * (verticalMaxPoint - position)).toStringAsFixed(2), color: scaleTextColor);
      tp.paint(canvas, Offset(marginLeft - tp.width - 5, positionY - 6));
    }

    for (var position = 0; position < horizontalMaxPoint; position++) {
      var positionX = distance * position + marginLeft;
      paint.color = scaleLineColor;
      canvas.drawLine(Offset(positionX, size.height - marginBottom), Offset(positionX, size.height - marginBottom - 5), paint);
      if (position % labelInterval == 0 && position + start < items.length) {
        TextPainter tp = getTextPainter(items[start + position].key, color: scaleTextColor);
        tp.paint(
          canvas,
          Offset(positionX - tp.width / 2, size.height - marginBottom + 5),
        );
      }
    }
  }

  drawBrokenLine(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = lineColor;
    paint.style = PaintingStyle.fill;
    for (var position = 0; position < points.length - 1; position++) {
      canvas.drawLine(Offset(points[position].px, points[position].py), Offset(points[position + 1].px, points[position + 1].py), paint);
    }

    paint.style = PaintingStyle.fill;
    if (hasDotOnPointOfJunction) {
      for (var position = 0; position < points.length; position++) {
        if (position == _selectedPosition) {
          continue;
        }
        canvas.drawCircle(Offset(points[position].px, points[position].py), 3, paint);
      }
    }
  }

  drawSelectedLabel(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = selectedColor
      ..style = PaintingStyle.fill;
    if (_selectedPosition != null && start + _selectedPosition! < items.length && selectedLabelBuilder != null) {
      canvas.drawCircle(Offset(points[_selectedPosition!].px, points[_selectedPosition!].py), 5, paint);
      TextPainter tp = getTextPainter(selectedLabelBuilder!(items[start + _selectedPosition!].key, items[start + _selectedPosition!].value), color: scaleTextColor);
      tp.paint(canvas, Offset(size.width - marginRight - tp.width, 0));
    }
  }

  drawBackground(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  TextPainter getTextPainter(text, {color = Colors.white}) {
    TextSpan span = TextSpan(text: "$text", style: getTextStyle(color));
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }

  TextStyle getTextStyle(Color color) {
    return TextStyle(fontSize: 12, color: color);
  }

  @override
  void paint(Canvas canvas, Size size) {
    calculatePoints(size);
    drawBackground(canvas, size);
    drawBorder(canvas, size);
    drawScale(canvas, size);
    drawBrokenLine(canvas, size);
    drawSelectedLabel(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
