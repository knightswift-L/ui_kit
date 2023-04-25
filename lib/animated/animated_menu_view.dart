part of ui_kit;

enum Layout {
  top,
  left,
  right,
  bottom,
  leftTop,
  rightTop,
  bottomLeft,
  bottomRight,
  around
}

class AnimatedMenuView extends StatefulWidget {
  final Layout layout;
  final List<Widget> actionChild;
  final Widget child;
  final double radius;
  const AnimatedMenuView({
    super.key,
    required this.layout,
    required this.actionChild,
    required this.child,
    required this.radius,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedMenuViewState();
  }
}

typedef PageBuilder = Widget Function(BuildContext context);

class AnimatedRoute<T> extends ModalRoute<T> {
  final PageBuilder builder;
  AnimatedRoute(this.builder);
  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "AnimatedRoute";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}

class _AnimatedMenuViewState extends State<AnimatedMenuView> {
  late GlobalKey globalKey;
  double opacity = 1.0;
  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
  }

  void onTap() {
    var target = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (target != null) {
      setState(() {
        opacity = 0.0;
      });
      var position = target.localToGlobal(Offset.zero);
      Navigator.push(
          context,
          AnimatedRoute<int?>((context) => _AnimatedPage(
            offset: position,
            layout: widget.layout,
            radius: widget.radius,
            children: [...widget.actionChild, widget.child],
          ))).then((value) {
        setState(() {
          opacity = 1.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
      return  GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          key: globalKey,
          child: Opacity(
            opacity: opacity,
            child: widget.child,
          ),
        ),
      );
    });
  }
}

class _AnimatedPage extends StatefulWidget {
  final List<Widget> children;
  final Offset offset;
  final Layout layout;
  final double radius;
  const _AnimatedPage({
    super.key,
    required this.children,
    required this.offset,
    required this.layout,
    required this.radius,
  });
  @override
  State<StatefulWidget> createState() {
    return _AnimatedPageState();
  }
}

class _AnimatedPageState extends State<_AnimatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double animatedValue = 0.0;
  Size size = MediaQueryData.fromWindow(window).size;
  Orientation? _orientation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
    animationController.addListener(() {
      setState(() {
        animatedValue = animationController.value;
      });
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
      if(_orientation != null && _orientation != orientation){
        Navigator.pop(context);
        return const SizedBox();
      }else{
        _orientation = orientation;
      }
      return WillPopScope(
          child: Stack(
            children: [
              CustomAnimatedMultiLayout(
                position: widget.offset,
                radius: widget.radius,
                animatedValue: animatedValue,
                layout: widget.layout,
                children: widget.children
                    .map((e) => GestureDetector(
                  onTap: () {
                    animationController.reverse().then((value) {
                      if (mounted) {
                        Navigator.pop(
                            context, widget.children.indexOf(e));
                      }
                    });
                  },
                  child: e,
                ))
                    .toList(),
              )
            ],
          ),
          onWillPop: () {
            animationController.reverse().then((value) {
              if (mounted) {
                Navigator.pop(context, null);
              }
            });
            return Future.value(false);
          });
    });
  }
}

class CustomAnimatedMultiLayout extends MultiChildRenderObjectWidget {
  final Offset position;
  final double radius;
  final double animatedValue;
  final Layout layout;
  CustomAnimatedMultiLayout(
      {super.key,
        super.children,
        required this.position,
        required this.radius,
        required this.animatedValue,
        required this.layout});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomMultiLayoutRenderObject(
        position, radius, animatedValue, layout);
  }

  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key &&
        ((oldWidget as CustomAnimatedMultiLayout).children !=
            (newWidget as CustomAnimatedMultiLayout).children ||
            (oldWidget).position != (newWidget).position ||
            (oldWidget).radius != (newWidget).radius ||
            (oldWidget).animatedValue != (newWidget).animatedValue ||
            oldWidget.layout != newWidget.layout);
  }

  @override
  void updateRenderObject(context, CustomMultiLayoutRenderObject renderObject) {
    renderObject
      ..position = position
      ..radius = radius
      ..animatedValue = animatedValue
      ..layoutDirection = layout;
  }
}

class CustomMultiLayoutRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomMultiLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            CustomMultiLayoutParentData> {
  Offset _position;
  set position(Offset position) {
    if (_position != position) {
      _position = position;
      markNeedsLayout();
    }
  }

  double _radius;
  set radius(double radius) {
    if (_radius != radius) {
      _radius = radius;
      markNeedsLayout();
    }
  }

  double _animatedValue;
  set animatedValue(double animatedValue) {
    if (_animatedValue != animatedValue) {
      _animatedValue = animatedValue;
      markNeedsLayout();
    }
  }

  Layout _layoutDirection;
  set layoutDirection(Layout layout) {
    if (_layoutDirection != layout) {
      _layoutDirection = layout;
      markNeedsLayout();
    }
  }

  CustomMultiLayoutRenderObject(
      Offset position, double radius, double animatedValue, Layout layout)
      : _position = position,
        _radius = radius,
        _animatedValue = animatedValue,
        _layoutDirection = layout;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CustomMultiLayoutParentData) {
      child.parentData = CustomMultiLayoutParentData();
    }
  }

  @override
  void performLayout() {
    BoxConstraints constraints = this.constraints;
    RenderBox? child;
    Offset? center;
    CustomMultiLayoutParentData childParentData;
    var children = getChildrenAsList();
    double angle = pi;
    switch (_layoutDirection) {
      case Layout.top:
      case Layout.left:
      case Layout.right:
      case Layout.bottom:
        {
          angle = pi / (children.length - 2);
        }
        break;
      case Layout.leftTop:
      case Layout.rightTop:
      case Layout.bottomLeft:
      case Layout.bottomRight:
        {
          angle = pi / 2 / (children.length - 2);
        }
        break;
      case Layout.around:
        {
          angle = pi * 2 / (children.length - 1);
        }
        break;
    }
    for (var index = 0; index < children.length - 1; index++) {
      child = children[index];
      childParentData = child.parentData! as CustomMultiLayoutParentData;
      center ??= _position + const Offset(15, 15);
      var rotateAngle = angle * index;
      var dx = _radius * _animatedValue * sin(rotateAngle + getRotate());
      var dy = _radius * _animatedValue * cos(rotateAngle + getRotate());
      childParentData.offset = (center - Offset(dx, dy)) -
          Offset(15 * (_animatedValue), 15 * (_animatedValue));
      child.layout(
        constraints.copyWith(
            maxHeight: 30 * _animatedValue, maxWidth: 30 * _animatedValue),
        parentUsesSize: true,
      );
    }

    child = lastChild;
    if (child != null) {
      childParentData = child.parentData! as CustomMultiLayoutParentData;
      childParentData.offset =
          _position + const Offset(15, 15) * _animatedValue;
      child.layout(
        constraints.copyWith(
            maxHeight: 30 * (1 - _animatedValue),
            maxWidth: 30 * (1 - _animatedValue)),
        parentUsesSize: true,
      );
    }

    size = getSize(constraints);
  }

  Size getSize(BoxConstraints constraints) {
    switch (_layoutDirection) {
      case Layout.top:
        return Size(constraints.maxWidth, _position.dy + 30);
      case Layout.left:

      case Layout.right:
        return Size(constraints.maxWidth, _position.dy + 30 * 1 + _radius);
      case Layout.bottom:
        return Size(constraints.maxWidth, _position.dy + 30 * 1.5 + _radius);
      case Layout.leftTop:
      case Layout.rightTop:
        return Size(constraints.maxWidth, _position.dy + 30);
      case Layout.bottomLeft:
      case Layout.bottomRight:
        return Size(constraints.maxWidth, _position.dy + 30 * 1 + _radius);
      case Layout.around:
        return Size(constraints.maxWidth, _position.dy + 30 * 1 + _radius);
    }
  }

  double getRotate() {
    switch (_layoutDirection) {
      case Layout.top:
        return -pi / 2;
      case Layout.left:
        return 0;
      case Layout.right:
        return pi;
      case Layout.bottom:
        return pi / 2;
      case Layout.leftTop:
        return 0.0;
      case Layout.rightTop:
        return -pi / 2;
      case Layout.bottomLeft:
        return pi / 2;
      case Layout.bottomRight:
        return pi;
      case Layout.around:
        return 0.0;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class CustomMultiLayoutParentData extends ContainerBoxParentData<RenderBox> {}