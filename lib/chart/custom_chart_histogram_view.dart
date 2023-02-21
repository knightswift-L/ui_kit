part of ui_kit;

class CHistogramItem {
  double value;
  String key;
  CHistogramItem(this.value, this.key);
}

class _CHistogramPath {
  Offset topLeft;
  Offset topRight;
  Offset bottomRight;
  Offset bottomLeft;
  _CHistogramPath(this.topLeft, this.topRight, this.bottomRight, this.bottomLeft);
}

class _HistogramNotification {
  double scrollX = 0;
  double selected = -1;
  bool isRepaint = false;
}
class CustomHistogramChartView extends StatefulWidget {
  final List<CHistogramItem> items;
  final int horizontalMaxCylinder;
  final Color scaleLineColor;
  final Color scaleTextColor;
  final Color backgroundColor;
  final Color cylinderColor;
  final int verticalMaxScale;
  final int labelInterval;
  CustomHistogramChartView({
    Key? key,
    this.items = const [],
    this.horizontalMaxCylinder = 5,
    this.verticalMaxScale = 5,
    this.backgroundColor = Colors.blue,
    this.cylinderColor = Colors.white,
    this.scaleTextColor = Colors.white,
    this.scaleLineColor = Colors.white,
    this.labelInterval = 5,
  }):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CustomHistogramChartViewState();
  }
}

class _CustomHistogramChartViewState extends State<CustomHistogramChartView> {
  double scrollX = 0;
  late StreamController<_HistogramNotification> _listener;
  double maxDistance = 0;
  double startX = 0;
  _HistogramNotification notification = _HistogramNotification();
  @override
  initState() {
    super.initState();
    _listener = StreamController<_HistogramNotification>();
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
        if(scrollX + (startX - current) > maxDistance){
          scrollX = maxDistance;
        }else if(scrollX + (startX - current) < 0) {
          scrollX = 0;
        }else{
          scrollX = scrollX + (startX - current);
        }
        notification.scrollX = scrollX;
        notification.isRepaint = true;
        _listener.add(notification);
        startX = current;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        startX = 0;
        notification.isRepaint = false;
        _listener.add(notification);
      },
      onLongPressStart: (LongPressStartDetails details) {
        notification.scrollX = scrollX;
        notification.isRepaint = true;
        notification.selected = details.localPosition.dx;
        _listener.add(notification);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        notification.selected = -1;
        // notification.isRepaint = false;
        _listener.add(notification);
      },
      child: StreamBuilder(
        stream: _listener.stream,
        builder: (BuildContext context, AsyncSnapshot<_HistogramNotification> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: _HistogramChartPainter(
                  items: widget.items,
                  horizontalMaxCylinder: widget.horizontalMaxCylinder,
                  scrollX: snapshot.data!.scrollX,
                  selectedPosition: snapshot.data!.selected,
                  scaleLineColor: widget.scaleLineColor,
                  scaleTextColor: widget.scaleTextColor,
                  backgroundColor: widget.backgroundColor,
                  verticalMaxScale: widget.verticalMaxScale,
                  cylinderColor: widget.cylinderColor,
                  labelInterval: widget.labelInterval,
                  maxScrollDistance: (distance){
                    maxDistance = distance;
                  },isRepaint:snapshot.data!.isRepaint,
                ),
              ),
            );
          }
          return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: _HistogramChartPainter(
                  items: widget.items,
                  horizontalMaxCylinder: widget.horizontalMaxCylinder,
                  scrollX: 0,
                  selectedPosition: -1,
                  scaleLineColor: widget.scaleLineColor,
                  scaleTextColor: widget.scaleTextColor,
                  backgroundColor: widget.backgroundColor,
                  verticalMaxScale: widget.verticalMaxScale,
                  cylinderColor: widget.cylinderColor,
                  labelInterval: widget.labelInterval,
                    maxScrollDistance: (distance){
                      maxDistance = distance;
                  },
                  isRepaint:false,
                ),
              ));
        },
      ),
    );
  }
}

class _HistogramChartPainter extends CustomPainter {
  List<CHistogramItem> items = [];
  List<_CHistogramPath> paths = [];

  final int horizontalMaxCylinder;
  final Color scaleLineColor;
  final Color scaleTextColor;
  final Color backgroundColor;
  final Color cylinderColor;
  final int verticalMaxScale;
  final int labelInterval;
  double scrollX;
  double selectedPosition;

  MaxScrollDistance maxScrollDistance;


  int start = 0;
  var distance = 0.0;
  var maxY = 0.0;
  double availableWidth = 0.0;
  double availableHeight = 0.0;
  final double marginLeft = 50;
  final double marginTop = 20;
  final double marginBottom = 20;
  final double marginRight = 20;
  double offset = 0.0;
  bool isRepaint;
  _HistogramChartPainter({
    this.items = const [],
    required this.horizontalMaxCylinder,
    required this.scrollX,
    required this.selectedPosition,
    required this.scaleLineColor,
    required this.scaleTextColor,
    required this.backgroundColor,
    required this.cylinderColor,
    required this.verticalMaxScale,
    required this.labelInterval,
    required this.maxScrollDistance,
    required this.isRepaint,
  });

  calculatePath(Size size) {
    availableWidth = size.width - marginLeft - marginRight;
    availableHeight = size.height - marginTop - marginBottom;
    distance = availableWidth / ((horizontalMaxCylinder + 1) / 2 + horizontalMaxCylinder);
    offset = scrollX % (1.5 * distance);
    double _maxDistance = items.length < horizontalMaxCylinder ? 0 : (items.length + (items.length + 1) / 2) * distance - availableWidth;
    maxScrollDistance(_maxDistance);
    start = (scrollX / (distance * 1.5)).floor();
    paths.clear();
    var maxValue = 0.0;
    for (var position = 0; position < horizontalMaxCylinder && position < items.length - start; position++) {
      maxValue = items[start + position].value > maxValue ? items[start + position].value : maxValue;
    }
    maxY = 1.2 * maxValue;
    paths.clear();
    var initOffset = 0.0;
    for (var position = 0; position < items.length - start; position++) {
        var startX = initOffset + distance * (position -1) + distance / 2 * (position) + marginLeft;
        var currentDistance = distance;
        if(position == 0){
          if(offset < 0.5 * distance){
            startX = 0.5 * distance - offset + marginLeft;
            initOffset = 0.5 * distance - offset + distance;
          }else{
            startX = marginLeft;
            currentDistance = 1.5 * distance - offset;
            initOffset = currentDistance;
          }
        }
        var height = items[start + position].value / maxY * availableHeight;
        var startY = size.height - marginBottom - height;
        if(startX + currentDistance >=  size.width - marginRight) {
          var leftDistance = size.width - marginRight - startX;
          leftDistance = leftDistance < 0 ? 0 :leftDistance;
          var availableDistance = Math.min(currentDistance,leftDistance );
          paths.add(_CHistogramPath(Offset(startX, startY), Offset(startX + availableDistance, startY), Offset(startX + availableDistance, startY + height), Offset(startX, startY + height)));
          break;
        }else{
          paths.add(_CHistogramPath(Offset(startX, startY), Offset(startX + currentDistance, startY), Offset(startX + currentDistance, startY + height), Offset(startX, startY + height)));
        }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = Colors.blue;
    calculatePath(size);
    drawBackground(canvas, size, paint);
    drawScale(canvas, size, paint);
    drawHistogram(canvas, size, paint);
    drawKey(canvas, size);
  }

  drawScale(Canvas canvas, Size size, Paint paint) {
    for (var position = 0; position < verticalMaxScale; position++) {
      paint.color = scaleLineColor;
      canvas.drawLine(Offset(marginLeft, availableHeight / verticalMaxScale * position + marginTop), Offset(marginLeft + 5, availableHeight / verticalMaxScale * position + marginTop), paint);
      var text = (maxY / verticalMaxScale * (verticalMaxScale - position)).toStringAsFixed(2);
      TextPainter tp = getTextPainter(text, color: scaleTextColor);
      tp.paint(canvas, Offset(marginLeft - tp.width - 5, availableHeight / verticalMaxScale * position + marginTop - 6));
    }
  }

  drawHistogram(Canvas canvas, Size size, Paint paint) {
    paint.color = cylinderColor;
    paths.forEach((element) {
      canvas.drawRect(Rect.fromLTRB(element.topLeft.dx, element.topLeft.dy, element.topRight.dx, element.bottomLeft.dy), paint);
    });
    if (selectedPosition != -1) {
      var position = ((selectedPosition + offset - marginLeft - distance / 4) / (1.5 * distance)).floor();
      TextPainter tp = getTextPainter(items[start + position].value.toStringAsFixed(2), color: scaleTextColor);
      var startX = tp.width > distance ? paths[position].topLeft.dx - ((tp.width - distance) / 2) : paths[position].topLeft.dx + ((distance - tp.width) / 2);
      tp.paint(canvas, Offset(startX, paths[position].topLeft.dy - tp.height - 5));
    }
  }

  drawBackground(Canvas canvas, Size size, Paint paint) {
    paint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    paint.color = Colors.white;
    canvas.drawLine(Offset(50, 20), Offset(50, size.height - 20), paint);
    canvas.drawLine(Offset(50, size.height - 20), Offset(size.width - 20, size.height - 20), paint);
  }

  drawKey(Canvas canvas, Size size) {
    for (var position = 0; position < paths.length; position++) {
      if(position % labelInterval == 0) {
        TextPainter tp = getTextPainter(items[start + position].key, color: scaleTextColor);
        var startX = tp.width > distance ? paths[position].topLeft.dx - ((tp.width - distance) / 2) : paths[position].topLeft.dx + ((distance - tp.width) / 2);
        tp.paint(canvas, Offset(startX, size.height - marginBottom + 5));
      }
    }
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return isRepaint;
  }
}
