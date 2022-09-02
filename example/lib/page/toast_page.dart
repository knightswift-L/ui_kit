import 'package:flutter/material.dart';
import 'package:ui_kit/toast.dart';

class ToastPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toast Page"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             TextButton(onPressed: (){
               showToast(message: "nt型，用于添加项目成员时获取企业成员列表并去除该项目已有的成员，默认为空，表示不去除，和参数isForAddProjMember联合使用",
                   style: TextStyle(inherit:false,fontSize: 18,color: Colors.red),backgroundColor: Colors.blue);
             }, child: Text("Normal Toast",)),
            TextButton(onPressed: (){
              showToast(customWidget: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12
                ),
                alignment: Alignment.center,
                child: Text("I'm a custom Toast",style: TextStyle(inherit: false,fontSize: 18),),
              ),
              );
            }, child: Text("Custom Toast"))
          ],
        ),
      )
    );
  }

}