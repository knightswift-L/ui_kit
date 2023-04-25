
import 'package:flutter/material.dart';
import 'package:ui_kit_example/page/image_pre_view_page.dart';
import 'package:ui_kit_example/page/toast_page.dart';

import 'animated_menu_page.dart';
import 'auto_refresh_page.dart';
import 'custom_chart_page.dart';
import 'date_picker_page.dart';
import 'dismissible_view_page.dart';

typedef Widget PageRouteBuilder(BuildContext context);
class PageItem{
  String title;
  PageRouteBuilder builder;
  PageItem({required this.title,required this.builder});
}

class HomePage extends StatelessWidget{
  final List<PageItem> pageItems = [
    PageItem(title: "Custom Chart Page",builder: (BuildContext context)=>CustomChartPage()),
    PageItem(title: "Toast Page",builder: (BuildContext context)=>ToastPage()),
    PageItem(title: "AutoRefresh Page",builder: (BuildContext context)=>AutoRefreshPage()),
    PageItem(title: "ImagePreView Page",builder: (BuildContext context)=>ImagePreViewPage()),
    PageItem(title: "DatePicker Page",builder: (BuildContext context)=>DatePickerPage()),
    //AnimatedMenuPage
    PageItem(title: "AnimatedMenu Page",builder: (BuildContext context)=>AnimatedMenuPage()),
    //DismissibleViewPage
    PageItem(title: "DismissibleView Page",builder: (BuildContext context)=>DismissibleViewPage()),
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Home"),
     ),
     body: ListView.separated(itemBuilder: (BuildContext context,int index){
       return GestureDetector(
         onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: pageItems[index].builder));
         },
         behavior: HitTestBehavior.opaque,
         child: Container(
           height: 50,
           width: double.infinity,
           color: Colors.white,
           padding: EdgeInsets.symmetric(
             horizontal: 20
           ),
           child: Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Expanded(child: Text(pageItems[index].title)),
               Icon(Icons.keyboard_arrow_right,size: 30,)
             ],
           ),
         ),
       );
     }, separatorBuilder: (BuildContext context,int index){
       return Divider(color: Colors.grey,);
     }, itemCount: pageItems.length),
   );
  }

}