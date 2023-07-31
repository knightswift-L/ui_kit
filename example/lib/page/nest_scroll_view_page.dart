import 'package:flutter/material.dart';

class NestScrollViewPage extends StatefulWidget{
  const NestScrollViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NestScrollViewPageState();
  }

}

class _NestScrollViewPageState extends State<NestScrollViewPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NestScrollViewPage"),),
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(child:  Container(
            height: 100,
            width: double.infinity,
            color: Colors.red,
          ),)
        ];
      }, body: CustomScrollView(
        slivers: List<Widget>.generate(100, (index) => SliverToBoxAdapter(
          child: Container(
            height: 100,
            width: double.infinity,
            color: index % 2 == 0 ? Colors.amber:Colors.blue,
          ),
        )),
      ),),
    );
  }

}