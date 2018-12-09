
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/months.dart' as mu;

class Task{
  final formatDate = DateFormat('yyyy-MM-dd');

  int _id;
  String _title = '';
  DateTime _date;
  int _month;
  int _day;
  TimeOfDay _time;
  num _reiteration = 1;
  String _reiterationTarget = 'MONTH';
  num _notification = 1;
  String _notificationTarget = 'DAY';

  Task(
    this._title,
    this._date,
    this._time,
    this._month,
    this._day,
    this._reiteration,
    this._reiterationTarget,
    this._notification,
    this._notificationTarget,
  );

  Task.empty();

  int get id => _id;

  set title(String title) => this._title = title;
  String get title => this._title;

  set date(DateTime date) => this._date = date;
  DateTime get date => this._date;

  set time(TimeOfDay time) => this._time = time;
  TimeOfDay get time => this._time;

  set month(int month) => this._month = month;
  int get month => this._month;

  set day(int day) => this._day = day;
  int get day => this._day;

  set reiteration(num reiteration) => this._reiteration = reiteration;
  num get reiteration => this._reiteration;

  set reiterationTarget(String reiterationTarget) => this._reiterationTarget = reiterationTarget;
  String get reiterationTarget => this._reiterationTarget;

  set notification(num notification) => this._notification = notification;
  num get notification => this._notification;

  set notificationTarget(String notificationTarget) => this._notificationTarget = notificationTarget;
  String get notificationTarget => this._notificationTarget;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map = {
      'title': _title,
      'date': formatDate.format(_date),
      'time': '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
      'month': _month,
      'day': _day,
      'reiteration': _reiteration,
      'reiterationTarget': _reiterationTarget,
      'notification': _notification,
      'notificationTarget': _notificationTarget
    };

    if(_id != null) map['id'] = _id;

    return map;
  }

  Task.map(Map object){
    this._id = object['id'];
    this._title = object['title'];
    this._date = formatDate.parse(object['date']);
    this._time = stringToTime(object['time']);
    this._month = object['month'];
    this._day = object['day'];
    this._reiteration = object['reiteration'];
    this._reiterationTarget = object['reiterationTarget'];
    this._notification = object['notification'];
    this._notificationTarget = object['notificationTarget'];
  }
   
  TimeOfDay stringToTime(String timeAsString){
    List<String> splitedTime = timeAsString.split(':');
    int hours = int.parse(splitedTime[0]);
    int minutes = int.parse(splitedTime[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  }

  String humanReadableDate(){
    return '${_day.toString().padLeft(2, '0')}, ${mu.findMonthByNumber(_month)['name']}';
  }
}