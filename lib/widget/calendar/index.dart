import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

/*
 * 自定义风格+多选
 */
class MultiSelectStylePage extends StatefulWidget {
  final ValueChanged<List<DateTime>> onValueChange;
  final ValueChanged<List<DateTime>> onSubmit;
  final VoidCallback onCancle;
  MultiSelectStylePage(
      {Key key, this.onValueChange, this.onSubmit, this.onCancle})
      : super(key: key);

  @override
  _MultiSelectStylePageState createState() => _MultiSelectStylePageState();
}

class _MultiSelectStylePageState extends State<MultiSelectStylePage> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = new CalendarController(
        selectMode: CalendarConstants.MODE_MULTI_SELECT,
        maxMultiSelectCount: 2,
        minSelectYear: 2019,
        selectedDateTimeList: {
          DateTime.now(),
        });

    controller.addMonthChangeListener(
      (year, month) {
        text.value = "$year年$month月";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      // List<DateTime> mutiValue = controller
      //     .getMultiSelectCalendar()
      //     .toList()
      //     .map((e) => e.getDateTime())
      //     .toList();
      // // print('dateModel:$mutiValue');

      // widget.onValueChange.call(mutiValue);
    });

    text = new ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");

    selectText = new ValueNotifier(
        "多选模式\n选中的时间:\n${controller.getMultiSelectCalendar().join("\n")}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  widget.onCancle();
                },
                child: Text('取消')),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                ValueListenableBuilder(
                    valueListenable: text,
                    builder: (context, value, child) {
                      return new Text(text.value);
                    }),
                IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    })
              ],
            ),
            FlatButton(
                onPressed: () {
                  List<DateTime> mutiValue = controller
                      .getMultiSelectCalendar()
                      .toList()
                      .map((e) => e.getDateTime())
                      .toList();
                  widget.onSubmit.call(mutiValue);
                },
                child: Text('确认'))
          ],
        ),
        CalendarViewWidget(
            verticalSpacing: 0,
            calendarController: controller,
            weekBarItemWidgetBuilder: () {
              return CustomStyleWeekBarItem();
            },
            dayWidgetBuilder: (dateModel) {
              return CustomStyleDayWidget(dateModel);
            }),
      ],
    ));
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCustomDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    bool isInRange = dateModel.isInRange;

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange ? Colors.grey : Colors.black, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange ? Colors.grey : Colors.grey, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    //绘制背景
    Paint backGroundPaint = new Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}
