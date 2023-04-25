part of ui_kit;

class CPieItem {
  double value;
  String key;
  Color color;
  CPieItem(this.value, this.key, this.color);
}

class _CPieAngle {
  double startAngle;
  double angle;
  Color color;
  _CPieAngle(this.startAngle, this.angle, this.color);
}

class CustomPieChartView extends StatefulWidget {
  final List<CPieItem> items;
  CustomPieChartView({required this.items});
  @override
  State<StatefulWidget> createState() {
    return _CustomPieChartViewState();
  }
}

class _PieNotification {
  Offset location;
  bool isSelected;
  _PieNotification(this.location, this.isSelected);
}

class _CustomPieChartViewState extends State<CustomPieChartView> {
  late StreamController<_PieNotification> _listener;
  @override
  initState() {
    super.initState();
    _listener = StreamController();
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
        onLongPressStart: (LongPressStartDetails detail) {
          _listener.add(_PieNotification(detail.localPosition, true));
        },
        onLongPressEnd: (LongPressEndDetails detail) {
          _listener.add(_PieNotification(detail.localPosition, false));
        },
        child: StreamBuilder(
          stream: _listener.stream,
          builder: (BuildContext context, AsyncSnapshot<_PieNotification> snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: _PieChartPainter(items: widget.items, pieNotification: snapshot.data!),
                ),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: _PieChartPainter(items: widget.items, pieNotification: _PieNotification(Offset(0, 0), false)),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  List<CPieItem> items;
  List<_CPieAngle> angles = [];
  Color backgroundColor;
  double radius;
  int? selectedPosition;
  _PieNotification pieNotification;
  _PieChartPainter({this.backgroundColor = Colors.white, this.radius = 0, required this.items, required this.pieNotification});

  calculateAngle(Size size) {
    angles.clear();
    var currentAngle = - Math.pi/2;
    var amount = items.fold<double>(0, (previousValue, element) => previousValue + element.value);
    for (var position = 0; position < items.length; position++) {
      var angle = items[position].value / amount * Math.pi * 2;
      angles.add(_CPieAngle(currentAngle, angle, items[position].color));
      if (pieNotification.isSelected) {
        if (isPointInCircularSector(
          size.width / 2,
          size.height * 0.40,
          Math.cos(currentAngle + angle / 2),
          Math.sin(currentAngle + angle / 2),
          Math.pow(size.width * 0.3, 2).toDouble(),
          Math.cos(angle / 2),
          pieNotification.location.dx,
          pieNotification.location.dy,
        )) {
          selectedPosition = position;
        }
      }
      currentAngle = currentAngle + angle;
    }
  }

  bool isPointInCircularSector(double cx, double cy, double ux, double uy, double squaredR, double cosTheta, double px, double py) {
    assert(cosTheta > -1 && cosTheta < 1);
    assert(squaredR > 0.0);
    double dx = px - cx;
    double dy = py - cy;
    double squaredLength = dx * dx + dy * dy;
    if (squaredLength > squaredR) return false;
    double dot = dx * ux + dy * uy;
    if (dot >= 0 && cosTheta >= 0)
      return dot * dot > squaredLength * cosTheta * cosTheta;
    else if (dot < 0 && cosTheta < 0)
      return dot * dot < squaredLength * cosTheta * cosTheta;
    else
      return dot >= 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    radius = size.width / 2 * 0.35;
    calculateAngle(size);
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    for (var position = 0; position < angles.length; position++) {
      paint.color = angles[position].color;
      var rect = Rect.fromLTRB(size.width * 0.2, size.height * 0.1, size.width * 0.8, size.height * 0.7);
      if (position == selectedPosition) {
        rect = Rect.fromLTRB(size.width * 0.15, size.height * 0.05, size.width * 0.85, size.height * 0.75);
        TextPainter tp = getTextPainter("${items[position].key} ${(angles[position].angle/(Math.pi*2)).toStringAsFixed(2)}%",color: angles[position].color);
        tp.paint(canvas, Offset((size.width - tp.width)/2,size.height * 0.75 + (size.height * 0.2 - tp.height)/2 ));
      }
      canvas.drawArc(rect, angles[position].startAngle, angles[position].angle, true, paint);
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
    return true;
  }
}
