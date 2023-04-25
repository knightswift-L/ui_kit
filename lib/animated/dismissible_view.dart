part of ui_kit;

class DismissibleView extends StatefulWidget {
  final Widget child;
  final List<Widget> actionView;
  const DismissibleView(
      {super.key, required this.child, required this.actionView});

  @override
  State<StatefulWidget> createState() {
    return _DismissibleViewState();
  }
}

class _DismissibleViewState extends State<DismissibleView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Offset offset = Offset.zero;
  DismissibleViewManagerState? controller;
  bool isOpen = false;
  int _openTime = 0;
  final double actionViewWidth = 60;
  double _threshold = 0.0;
  @override
  void initState() {
    super.initState();
    _threshold = widget.actionView.length * actionViewWidth;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animationController.addListener(() {
      setState(() {
        offset *= (1 - animationController.value);
      });
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller =
          context.findAncestorStateOfType<DismissibleViewManagerState>();
      controller?.addListener(_approachScroll);
    });
  }

  void _approachScroll() {
    if (!isOpen) {
      return;
    }
    if ((controller?.scrolling ?? true) ||
        _openTime < (controller?.latestChildOpenTime ?? 0)) {
      isOpen = false;
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    controller?.removeListener(_approachScroll);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        var temp = DateTime.now().millisecondsSinceEpoch;
        _openTime = temp;
        controller?.updateLatestChildOpenTime(temp);
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        var temp = offset.dx + details.delta.dx;
        if (temp > 0) {
          temp = 0;
        } else if (temp < -_threshold) {
          temp = -_threshold;
          isOpen = true;
        }
        setState(() {
          offset = Offset(temp, 0);
        });
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (offset.dx > -_threshold) {
          animationController.forward(from: 0.0);
        }
      },
      child: DismissibleTranslation(
        offset: offset,
        threshold: _threshold,
        children: [widget.child, ...widget.actionView]
            .map(
              (e) => MultiTapGesture(
                child: e,
                onTap: () {
                  animationController.forward(from: 0.0);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class DismissibleTranslation extends MultiChildRenderObjectWidget {
  final Offset offset;
  final double threshold;
  DismissibleTranslation(
      {super.key,
      super.children,
      required this.offset,
      required this.threshold});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return DismissibleTranslationRenderObject(
        offset: offset, threshold: threshold);
  }

  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key &&
        ((oldWidget as DismissibleTranslation).offset !=
                (newWidget as DismissibleTranslation).offset ||
            oldWidget.children != newWidget.children ||
            oldWidget.threshold != newWidget.threshold);
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant DismissibleTranslationRenderObject renderObject) {
    renderObject
      ..offset = offset
      ..threshold = threshold;
  }
}

class DismissibleTranslationRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomMultiLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            CustomMultiLayoutParentData> {
  Offset _offset;
  set offset(Offset offset) {
    if (_offset == offset) {
      return;
    }
    _offset = offset;
    markNeedsPaint();
  }

  double _threshold;
  set threshold(double threshold) {
    if (_threshold == threshold) {
      return;
    }
    _threshold = threshold;
    markNeedsLayout();
  }

  DismissibleTranslationRenderObject(
      {required Offset offset, required double threshold})
      : _offset = offset,
        _threshold = threshold;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CustomMultiLayoutParentData) {
      child.parentData = CustomMultiLayoutParentData();
    }
  }

  @override
  performLayout() {
    RenderBox? mainChild = firstChild;
    CustomMultiLayoutParentData? childParentData;
    double width = 0.0;
    if (mainChild != null) {
      childParentData = mainChild.parentData as CustomMultiLayoutParentData?;
      childParentData!.offset = Offset.zero;
      mainChild.layout(constraints, parentUsesSize: true);
      width = mainChild.size.width;
    }
    var children = getChildrenAsList().sublist(1);
    for (var child in children) {
      childParentData = child.parentData as CustomMultiLayoutParentData?;
      childParentData!.offset = Offset(width, 0);
      child.layout(
          BoxConstraints.tight(
              Size(_threshold / children.length, mainChild!.size.height)),
          parentUsesSize: true);
      width += child.size.width;
    }
    size = Size(min(constraints.maxWidth, width), mainChild!.size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(
        context,
        Offset(
          offset.dx + _offset.dx,
          offset.dy + _offset.dy,
        ));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position - _offset);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translate(
      _offset.dx,
      _offset.dy,
    );
  }
}

class DismissibleViewManager extends StatefulWidget {
  final Widget child;
  const DismissibleViewManager({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return DismissibleViewManagerState();
  }
}

class DismissibleViewManagerState extends State<DismissibleViewManager>
    implements Listenable {
  final List<VoidCallback> _callbacks = [];

  bool _scrolling = false;
  bool get scrolling => _scrolling;
  int _latestChildOpenTime = 0;
  int get latestChildOpenTime => _latestChildOpenTime;
  @override
  void addListener(VoidCallback listener) {
    _callbacks.add(listener);
  }

  void updateLatestChildOpenTime(int time) {
    _latestChildOpenTime = time;
    _notifierAll();
  }

  _notifierAll() {
    for (var callbacks in _callbacks) {
      callbacks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          switch (notification.runtimeType) {
            case ScrollUpdateNotification:
            case ScrollStartNotification:
              {
                _scrolling = true;
                _notifierAll();
              }
              break;
            case ScrollEndNotification:
              {
                _scrolling = false;
                _notifierAll();
              }
          }
          return false;
        },
        child: widget.child);
  }

  @override
  void removeListener(VoidCallback listener) {
    _callbacks.remove(listener);
  }
}

class MultiTapGesture extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const MultiTapGesture({super.key, required this.onTap, required this.child});
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: {
      AllowMultiTapGesture:
          GestureRecognizerFactoryWithHandlers<AllowMultiTapGesture>(
              () => AllowMultiTapGesture(), (AllowMultiTapGesture instance) {
        instance.onTap = onTap;
      })
    }, child: child);
  }
}

class AllowMultiTapGesture extends TapGestureRecognizer {
  @override
  rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
