import 'package:flutter/material.dart';

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
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(milliseconds: 2000), () {});
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              height: 100,
              color: index % 2 == 0 ? Colors.blue : Colors.red,
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
