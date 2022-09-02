import 'package:flutter/material.dart';
enum ToastTime {
  Long, // 2000ms
  short // 1500ms
}

void showToast({String? message, Widget? customWidget, ToastTime? toastTime,TextStyle? style,Color? backgroundColor}) {
  if (message == null && customWidget == null) {
    throw "one of message and customWidget must not be null";
  }
  if (customWidget == null) {
    Toast().showToast(ToastEvent(toastTime: toastTime ?? ToastTime.short, message: message!,backgroundColor:backgroundColor,style: style));
  } else {
    Toast().showToast(ToastEvent(toastTime: toastTime ?? ToastTime.short, contentWidget: customWidget));
  }
}

class ToastEvent {
  ToastTime toastTime;
  Widget? contentWidget;
  String? message;
  TextStyle? style;
  Color? backgroundColor;
  ToastEvent({this.toastTime = ToastTime.short, this.contentWidget, this.message,this.style,this.backgroundColor});
}

class Toast {
  BuildContext? context;
  Toast._internal();
  static final Toast _singleton = Toast._internal();

  factory Toast() => _singleton;
  void init(BuildContext _context) {
    context = _context;
    _events.clear();
  }

  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  final List<ToastEvent> _events = [];
  void showToast(ToastEvent? arg) {
    if (_events.isEmpty && arg != null) {
      _events.add(arg);
      _insertToastOverEntry(arg);
    } else if (_events.isNotEmpty && arg != null) {
      _events.add(arg);
    } else if (_events.isNotEmpty && arg == null) {
      _insertToastOverEntry(_events.first);
    }
  }

  void _hideToast() {
    if (overlayState != null && overlayEntry != null) {
      _events.removeAt(0);
      overlayEntry!.remove();
      if (_events.isNotEmpty) {
        showToast(null);
      }
    }
  }

  void _insertToastOverEntry(ToastEvent event) {
    overlayState = Overlay.of(context!);
    if(event.message == null){
      overlayEntry = OverlayEntry(builder: (context) {
        return Center(
          child: UnconstrainedBox(
            child:event.contentWidget
          ),
        );
      });
    }else{
      TextStyle style = event.style ?? const TextStyle(inherit: false,fontSize: 16,color: Colors.white);
      Color backgroundColor = event.backgroundColor ?? Colors.grey;
      overlayEntry = OverlayEntry(builder: (context) {
        return Center(
          child: UnconstrainedBox(
            child:Container(
              width: getTextWidth(event.message!,style) <= MediaQuery.of(context).size.width * 0.8 - 40 ?  getTextWidth(event.message!,TextStyle(inherit: false,fontSize: 16,color: Colors.white)) + 40 :  MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              alignment: Alignment.center,
              child: Text(event.message!,style: style,textAlign: TextAlign.center,maxLines:2,overflow: TextOverflow.ellipsis,),
            ),
          ),
        );
      });
    }

    if (overlayState != null && overlayEntry != null) {
      overlayState!.insert(overlayEntry!);
    }
    Future.delayed(Duration(milliseconds: event.toastTime == ToastTime.short ? 1500 : 2000), () {
      _hideToast();
    });
  }

     getTextWidth(String message, TextStyle style){
      TextSpan span = TextSpan(text: message, style: style);
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      return tp.width;
  }
}
