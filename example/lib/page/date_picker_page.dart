import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class DatePickerPage extends StatefulWidget{
  const DatePickerPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return DatePickerPageState();
  }

}

class DatePickerPageState extends State<DatePickerPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DatePicker(
          onDateSelected: (d){}, maxDate: DateTime(3000), minDate: DateTime(1970),
        )
      ),
    );
  }

}