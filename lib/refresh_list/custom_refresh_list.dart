import 'dart:async';

import 'package:flutter/material.dart';
typedef OnOperation = Future<bool> Function();
class EasyRefreshList extends StatefulWidget{
  final List<Widget> slivers;
  final OnOperation? onRefresh;
  final OnOperation? onLoad;
  const EasyRefreshList({super.key,required this.slivers,this.onLoad,this.onRefresh});

  @override
  State<StatefulWidget> createState() {
    return _EasyRefreshListState();
  }
}

class _EasyRefreshListState extends State<EasyRefreshList>{
  StreamController<double>? refreshStream;
  StreamController<double>? loadStream;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    if(widget.onRefresh != null){
      refreshStream = StreamController<double>();
    }
    if(widget.onLoad!= null){
      loadStream = StreamController<double>();
    }
  }

  bool _handleScrollNotification(OverscrollNotification notification){
    // if(notification is ScrollStartNotification || notification is ScrollUpdateNotification){
      print(notification.overscroll);
      switch (notification.metrics.axisDirection) {
        case AxisDirection.down:{
          _dragOffset -= notification.overscroll;
          if(_dragOffset > 50){
            _dragOffset = 50.0;
          }
          print(_dragOffset);
          refreshStream!.add(_dragOffset.abs());
          return true;
        }
        case AxisDirection.up:
        case AxisDirection.left:
        case AxisDirection.right:
      }
    // }

    // if(notification is ScrollEndNotification && notification.metrics.axisDirection == AxisDirection.down){
    //   refreshStream!.add(50);
      // return true;
    // }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: NotificationListener(
          onNotification: (OverscrollNotification notification){
            return _handleScrollNotification(notification);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if(widget.onRefresh != null)SliverToBoxAdapter(
                child: StreamBuilder(
                    initialData: 0.0,
                    stream: refreshStream?.stream,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot){
                      if(snapShot.hasData){
                        return Container(width: double.infinity,height: snapShot.data as double,color: Colors.blue,);
                      }
                      return const SizedBox();
                    }),
              ),
              ...widget.slivers,
              if(widget.onLoad != null)SliverToBoxAdapter(
                child: StreamBuilder(
                    initialData: 0.0,
                    stream: loadStream?.stream,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot){
                      if(snapShot.hasData){
                        return Container(width: double.infinity,height: snapShot.data as double,color: Colors.red,);
                      }
                      return const SizedBox();
                    }),
              ),
            ],
          )),
    );
  }

}