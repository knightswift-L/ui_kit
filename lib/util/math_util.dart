import 'dart:math';

class Coordinate{
  final double x;
  final double y;

  Coordinate(this.x, this.y);

  @override
  String toString() {
    return "x:$x  Y:$y";
  }
}


class MathUtil {
  static double getTargetY(double x1, double y1, double x2, double y2,
      double x) {
    var distance = x2 - x1;
    var k = (y2 - y1) / (x2 - x1);
    var b = -(k * distance - y2);
    var y = x * k + b;
    return y;
  }
  static Coordinate getCoordinateByAngle(double radius,double angle){
    final x = radius * sin(angle);
    final y = radius * cos(angle);
    return Coordinate(x, y);
  }

}