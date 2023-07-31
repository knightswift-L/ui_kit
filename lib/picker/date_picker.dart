part of ui_kit;

///
typedef void OnDateSelected(DateTime date);

///
class DatePicker extends StatefulWidget {
  ///
  final OnDateSelected onDateSelected;

  ///
  final DateTime minDate;

  ///
  final DateTime maxDate;

  ///
  final Color? activeColor;

  ///
  final Color? textColor;

  ///
  final double? itemHeight;

  ///
  DatePicker({
    required this.onDateSelected,
    required this.maxDate,
    required this.minDate,
    this.activeColor,
    this.textColor,
    this.itemHeight,
  });

  ///
  static custom({required OnDateSelected onDateSelected}) {
    DatePicker(onDateSelected: onDateSelected, minDate: DateTime.fromMillisecondsSinceEpoch(0), maxDate: DateTime.now());
  }

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<DatePicker> {
  final List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  final List<int> daysLeap = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  bool hasStartScroll = false;
  bool hasEndScroll = true;
  int? year;
  int? month;
  int? day;
  List<int>? dayOfCurrentMonth;
  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
    year = today.year;
    month = today.month;
    day = today.day;
    dayOfCurrentMonth = isLeapYear() ? daysLeap : days;
  }

  bool isLeapYear() {
    if (year! % 4 == 0 && year! % 100 != 00) {
      return true;
    }

    if (year! % 4 == 0 && year! % 400 == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WheelListView(
                    width: constraints.maxWidth / 4,
                    height: constraints.maxHeight,
                    itemHeight: 40,
                    items: List<String>.generate(DateTime.now().year - 1970 + 1, (int index) => "${1970 + index}年"),
                    onChanged: (int index) {
                      setState(() {
                        year = 1970 + index;
                        month = 1;
                        day = 1;
                        dayOfCurrentMonth = isLeapYear() ? daysLeap : days;
                        widget.onDateSelected(DateTime(year!, month!, day!));
                      });
                    },
                    initialPosition: year! - 1970,
                  ),
                  WheelListView(
                    width: constraints.maxWidth / 4,
                    height: constraints.maxHeight,
                    itemHeight: 40,
                    items: List<String>.generate(12, (int index) => "${index + 1}月"),
                    onChanged: (int index) {
                      setState(() {
                        month = 1 + index;
                        day = 1;
                        widget.onDateSelected(DateTime(year!, month!, day!));
                      });
                    },
                    initialPosition: month! - 1,
                  ),
                  WheelListView(
                    width: constraints.maxWidth / 4,
                    height: constraints.maxHeight,
                    itemHeight: 40,
                    items: List<String>.generate(dayOfCurrentMonth![month! - 1], (int index) => "${index + 1}日"),
                    onChanged: (int index) {
                      setState(() {
                        day = 1 + index;
                        widget.onDateSelected(DateTime(year!, month!, day!));
                      });
                    },
                    initialPosition: day! - 1,
                  ),
                ],
              ),
            ));
  }
}
