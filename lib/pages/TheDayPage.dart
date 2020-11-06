import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/TheDay.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/utils/DateUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TheDayPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TheDayPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  bool _hasLoadData = false;
  List<TheDay> _theDayList = [];
  Map<DateTime, List<TheDay>> _dateTheDayMap = {};
  DateTime _selectedDate;
  List<TheDay> _selectedTheDays = [];
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    loadData();
  }

  void loadData() {
    // TODO 一年一年拉？
    DataHelper.loadData(DataHelper.COLLECTION_THE_DAY, null).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _theDayList = (value.data as List)
            .map((e) => TheDay.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
        _groupTheDays();

        _selectedDate = DateUtils.date2ymd(DateTime.now());
        _selectedTheDays = _dateTheDayMap[_selectedDate] ?? [];
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
  
  void _groupTheDays() {
    // TODO 周年纪念日的xxx循环添加
    // 数据按日分组
    for(TheDay day in _theDayList) {
      DateTime date = DateUtils.str2ymd(day.theDayDate);
      List<TheDay> theDayList = _dateTheDayMap[date];
      if(theDayList == null) {
        _dateTheDayMap[date] = theDayList = List<TheDay>();
      }
      theDayList.add(day);
    }
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    _selectedDate = DateUtils.date2ymd(day);
    setState(() {
      _selectedTheDays = _dateTheDayMap[_selectedDate] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "theDayDetail",
              arguments: {"date": _selectedDate});
        },
      ),
    );
  }

  getBody() {
    if (_hasLoadData) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          Expanded(child: _buildEventList()),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'zh_CN',
      calendarController: _calendarController,
      events: _dateTheDayMap,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendStyle: TextStyle().copyWith(color: Colors.blue),
        outsideWeekendStyle: TextStyle().copyWith(color: Colors.blue[200]),
        selectedColor: Theme.of(context).primaryColor,
        todayColor: Theme.of(context).primaryColorLight,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.red
            : Colors.red[200],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedTheDays
          .map((event) => _buildEventRow(event))
          .toList(),
    );
  }

  Widget _buildEventRow(TheDay event) {
    return ListTile(
      title: Text(event.name),
      onTap: () => Navigator.pushNamed(context, "theDayDetail",
          arguments: {"date": _selectedDate, "theDay": event}),
    );
  }

  getProgress() {
    return Center(child: CircularProgressIndicator());
  }
}
