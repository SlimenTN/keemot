
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task{
  final formatDate = DateFormat('yyyy-MM-dd');

  int _id;
  String _title;
  DateTime _date;
  TimeOfDay _time;
  num _reiteration;
  String _reiterationTarget;
  num _notification;
  String _notificationTarget;

  Task(
    this._title,
    this._date,
    this._time,
    this._reiteration,
    this._reiterationTarget,
    this._notification,
    this._notificationTarget,
  );

  int get id => _id;

  set title(String title) => this._title = title;
  String get title => this._title;

  set date(DateTime date) => this._date = date;
  DateTime get date => this._date;

  set time(TimeOfDay time) => this._time = time;
  TimeOfDay get time => this._time;

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
}