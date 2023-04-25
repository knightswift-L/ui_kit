import 'package:flutter/material.dart';
import 'package:ui_kit/refresh_list/custom_refresh_list.dart';

class AutoRefreshPage extends StatefulWidget {
  const AutoRefreshPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AutoRefreshPageState();
  }
}

class _AutoRefreshPageState extends State<AutoRefreshPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AutoRefresh Page"),
      ),
      body: EasyRefreshList(
        onRefresh: (){
          return Future.value(true);
        },
        onLoad: (){
          return Future.value(true);
        },
        slivers: [],),
    );
  }
}
