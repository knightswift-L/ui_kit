class MathUtil{
  static double getTargetY(double x1,double y1,double x2,double y2,double x){
    var distance = x2 - x1;
    var k = (y2 -y1)/(x2 - x1);
    var b= -(k * distance - y2);
    var y = x * k + b;
    return y;
  }
}