part of ui_kit;

class CustomRadarItem {
  final String title;
  final double value;
  final String key;
  CustomRadarItem(
      {required this.key, required this.title, required this.value});
}

class CustomRadarGroup {
  final String title;
  final Color color;
  final Map<String, CustomRadarItem> maps;

  CustomRadarGroup({
    required this.title,
    required this.maps,
    required this.color,
  });
}

class CustomRadarView extends StatefulWidget {
  final double width;
  final double height;
  final List<CustomRadarItem> items;
  final int level;
  final List<CustomRadarGroup> maps;
  const CustomRadarView({
    super.key,
    required this.width,
    required this.height,
    required this.items,
    required this.level,
    required this.maps,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomRadarViewState();
  }
}

class _CustomRadarViewState extends State<CustomRadarView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: CustomRadarViewPainter(
          widget.items,
          widget.level,
          widget.maps,
        ),
      ),
    );
  }
}

class CustomRadarViewPainter extends CustomPainter {
  final List<CustomRadarItem> items;
  final List<CustomRadarGroup> maps;
  final int level;
  CustomRadarViewPainter(this.items, this.level, this.maps);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = Math.min(size.width, size.height) / 2 * 0.8;
    var center = Offset(size.width / 2, size.height / 2);
    drawGrid(canvas, center, radius);
    drawData(canvas, center, radius);
    drawCategory(canvas, size);
  }

  void drawCategory(Canvas canvas,Size size){
     double width = 0.0;
     for(CustomRadarGroup group in maps){
       TextPainter textPainter = TextPainter(
           text: TextSpan(
               text: group.title,
               style: const TextStyle(color: Colors.black)),
           textDirection: TextDirection.ltr);
       textPainter.layout();
       width += textPainter.width;
     }
     var offsetX = (size.width - 10 * (maps.length - 1 ) - width)/2;
     for(CustomRadarGroup group in maps){
       TextPainter textPainter = TextPainter(
           text: TextSpan(
               text: group.title,
               style: TextStyle(color: group.color)),
           textDirection: TextDirection.ltr);
       textPainter.layout();
       textPainter.paint(canvas, Offset(offsetX,size.height - textPainter.height -5));
       offsetX += 10 + textPainter.width;
     }
  }
  void drawData(Canvas canvas, Offset center, double radius) {
    var paint = Paint();
    var length = items.length;
    for (CustomRadarGroup element in maps) {
      paint.color = element.color;
      var point1 = MathUtil.getCoordinateByAngle(
          radius *
              ((element.maps[items.first.key]?.value ?? 0) / items.first.value),
          Math.pi * 2 / length * 0);
      Coordinate? pre;
      var path = Path();
      path.moveTo(center.dx + point1.x, center.dy - point1.y);
      for (var index = 1; index < items.length; index++) {
        var item = items[index];
        var point2 = MathUtil.getCoordinateByAngle(
            radius * ((element.maps[item.key]?.value ?? 0) / item.value),
            Math.pi * 2 / length * index);
        path.lineTo(center.dx + point2.x, center.dy - point2.y);
      }
      path.lineTo(center.dx + point1.x, center.dy - point1.y);
      canvas.drawPath(path, paint);
    }
  }

  void drawGrid(Canvas canvas, Offset center, double radius) {
    var paint = Paint()..color = Colors.grey;
    var length = items.length;
    for (var index = 0; index < length; index++) {
      var point1 =
          MathUtil.getCoordinateByAngle(radius, Math.pi * 2 / length * index);
      canvas.drawLine(
          center, Offset(center.dx + point1.x, center.dy - point1.y), paint);
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: items[index].title,
              style: const TextStyle(color: Colors.black)),
          textDirection: TextDirection.ltr);
      textPainter.layout();
      var position = Offset(center.dx + point1.x, center.dy - point1.y);
      if (position.dx < center.dx) {
        position = Offset(position.dx - textPainter.width, position.dy);
      }
      if (position.dy < center.dy) {
        position = Offset(position.dx, position.dy - textPainter.height);
      }
      textPainter.paint(canvas, position);
    }
    var paragraph = radius / level;
    for (var circle = 1; circle <= level; circle++) {
      for (var position = 0; position < length; position++) {
        var point1 = MathUtil.getCoordinateByAngle(
            paragraph * circle, Math.pi * 2 / length * position);
        var point2 = MathUtil.getCoordinateByAngle(paragraph * circle,
            Math.pi * 2 / length * ((position + 1) % length));
        canvas.drawLine(Offset(center.dx + point1.x, center.dy - point1.y),
            Offset(center.dx + point2.x, center.dy - point2.y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomRadarViewPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.maps != maps || oldDelegate.level != level;
  }
}
