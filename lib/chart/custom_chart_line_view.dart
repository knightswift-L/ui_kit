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
  toOffset(){
    return Offset(px, py);
  }
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

class _CustomLineChartViewState extends State<CustomLineChartView> with SingleTickerProviderStateMixin {
  double scrollX = 0.0;
  double maxDistance = 0;
  late StreamController<_Notification> _listener;
  double startX = 0;
  _Notification notification = _Notification();
  late AnimationController animationController;
  double currentAnimationValue = 0.0;
  @override
  void initState() {
    super.initState();
    _listener = StreamController<_Notification>();
    animationController = AnimationController(vsync: this,value: 1.0,duration: const Duration(seconds: 1))..addListener(() {
      currentAnimationValue = animationController.value;
      _listener.add(_Notification()..animatedValue = animationController.value..scrollX = 0.0);
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward(from: 0.0);
    });
  }

  @override
  dispose() {
    _listener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
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
          notification.animatedValue = currentAnimationValue;
          _listener.add(notification);
          startX = current;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          startX = 0;
        },
        onLongPressStart: (LongPressStartDetails details) {
          notification.scrollX = scrollX;
          notification.selected = details.localPosition.dx;
          notification.animatedValue = currentAnimationValue;
          _listener.add(notification);
        },
        onLongPressEnd: (LongPressEndDetails details) {
          notification.selected = -1;
          notification.animatedValue = currentAnimationValue;
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
                    animatedValue: snapshot.data!.animatedValue,
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
                  scrollX: 0.0,
                  scaleTextColor: widget.scaleTextColor,
                  scaleLineColor: widget.scaleLineColor,
                  backgroundColor: widget.backgroundColor,
                  lineColor: widget.lineColor,
                  labelInterval: widget.labelInterval,
                  hasDotOnPointOfJunction: widget.hasDotOnPointOfJunction,
                  selectedColor: widget.selectedColor,
                  animatedValue: 0.0,
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
      ),
    );
  }
}

class _Notification {
  double scrollX = double.infinity;
  double selected = -1;
  bool isRepaint = false;
  double animatedValue = 0.0;
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
  final double animatedValue;
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
    this.animatedValue = 1.0
  });
  double maxY = 0;
  double distance = 0;
  calculatePoints(Size size) {
    availableHeight = size.height - marginTop - marginBottom;
    availableWidth = size.width - marginLeft - marginRight;
    distance = availableWidth / (horizontalMaxPoint - 1);
    double _maxScrollDistance = items.length <= horizontalMaxPoint ? 0 : (distance * (items.length - 1)) - availableWidth;
    maxScrollDistance(_maxScrollDistance);
    var offset = scrollX != 0 ? scrollX % distance:0.0;
    if (scrollX >= _maxScrollDistance) {
      start = items.length <= horizontalMaxPoint ? 0 : items.length - horizontalMaxPoint;
    } else {
      start = (scrollX / distance).floor().toInt();
    }
    var maxValue = 0.0;
    for (var position = 0;  position < items.length; position++) {
      maxValue = maxValue > items[position].value ? maxValue : items[position].value;
    }

    maxY = maxValue;
    points.clear();
    for (var position = 0; position + start < items.length && position < items.length; position++) {
      var currentY = availableHeight * (1 - (items[position + start].value / maxY));
      if(position == 0){
        var lastY = availableHeight * (1 - (items[position + start + 1].value / maxY));
        var latestY = MathUtil.getTargetY(0, currentY, distance, lastY, offset);
        points.add(_CLinePoint(marginLeft,marginTop+ latestY));
      }else if((distance - offset) + distance * (position -1) + marginLeft > size.width - marginRight) {
        var lastY = availableHeight * (1 - (items[position + start-1].value / maxY));
         var latestY = MathUtil.getTargetY(0, lastY, distance, currentY, size.width - marginRight - ((distance - offset) + distance * (position -2) + marginLeft));
        points.add(_CLinePoint(size.width - marginRight, marginTop + latestY));
        break;
      }else{
        points.add(_CLinePoint((distance - offset) + distance * (position -1) + marginLeft, marginTop + currentY));
      }
    }

    if (selectedLocation == -1) {
      _selectedPosition = null;
    } else {
      var _selectedLocation = selectedLocation - marginLeft + offset;
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
      var positionX = distance * position + marginLeft - (scrollX % distance);
      paint.color = scaleLineColor;
      if(positionX > marginLeft) {
        canvas.drawLine(Offset(positionX, size.height - marginBottom), Offset(positionX, size.height - marginBottom - 5), paint);
        if ((position + start) % labelInterval == 0 && position + start < items.length) {
          TextPainter tp = getTextPainter(items[start + position].key, color: scaleTextColor);
          tp.paint(
            canvas,
            Offset(positionX - tp.width / 2, size.height - marginBottom + 5),
          );
        }
      }
    }
  }

  drawBrokenLine(Canvas canvas, Size size) {
    var shader =  LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [Colors.blue.withOpacity(0.6),Colors.transparent])
        .createShader(Rect.fromLTRB(30, 30, size.width-30, size.height-30));
    var paint = Paint()
    ..shader = shader
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = lineColor;
    paint.style = PaintingStyle.fill;
    var path = Path();
    var temp = points.map((e) => Point(e.px,e.py)).toList();
    var generate = temp.smooth(200).map((e) => _CLinePoint(e.x.toDouble(), e.y.toDouble())).toList();
    for (var position = 0; position < generate.length; position++) {
      if(position == 0 ){
        path.moveTo(generate[position].px, generate[position].py);
      }else{
        path.lineTo(generate[position].px, generate[position].py);
        }
    }
    // canvas.drawPath(path, paint);
    var pathMetrics = path.computeMetrics(forceClosed: false);
    var list = pathMetrics.toList();
    var length = list.length;
    if(length > 1){
      length = (length * animatedValue).toInt();
    }
    Path newPath = Path();
    if(length == 1){
      var extractPath =list[0].extractPath(0, list[0].length * animatedValue, startWithMoveTo: true);
      newPath.addPath(extractPath, const Offset(0, 0));
      var rect =extractPath.getBounds();
      newPath.lineTo(rect.right, size.height-marginBottom);
      newPath.lineTo(rect.left,size.height-marginBottom);
      newPath.lineTo(rect.left, points.first.py);
    }
    canvas.drawPath(newPath, paint);

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 6;
    if (hasDotOnPointOfJunction) {
      paint.shader = null;
      paint.style = PaintingStyle.stroke;
      for (var position = 0; position < points.length; position++) {
        if (position == _selectedPosition) {
          continue;
        }
        // canvas.drawCircle(Offset(points[position].px, points[position].py), 3, paint);
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
      ..color = Colors.grey;
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
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return true;
  }
}
