import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Alarm {
  TimeOfDay _alarmTime;
  bool _alarmOn;
  final DocumentReference reference;
  
  // Note({this.id, this.title, this.content, this.date_created, this.date_last_edited, this.reference});
  Alarm({TimeOfDay alarmTime, bool alarmOn, this.reference}) {
    this._alarmTime = alarmTime != null ? alarmTime : new TimeOfDay(hour: 0, minute: 0);
    this._alarmOn = alarmOn != null ? alarmOn : true;
  }

  set alarmTime(TimeOfDay time) {
    this._alarmTime = time;
  }

  set alarmOn(bool isOn) {
    this._alarmOn = isOn;
  }

  void setAlarmOn() {
    if (this._alarmOn) {
      this._alarmOn = false;
    } else {
      this._alarmOn = true;
    }
  }

  String convertAlarmTimeToString() {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, this._alarmTime.hour, this._alarmTime.minute);
    return DateFormat("HH:mm").format(dt);
  }

  get alarmTime {
    return this._alarmTime;
  }

  get alarmOn {
    return this._alarmOn;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'alarmTime': convertAlarmTimeToString(),
      'alarmOn': this._alarmOn
    };
  }

  Alarm.fromMap(Map<String, dynamic> json, {this.reference}) 
  : assert(json['alarmTime'] != null),
    _alarmTime = TimeOfDay(hour:int.parse(json["alarmTime"].split(":")[0]),minute: int.parse(json["alarmTime"].split(":")[1])),
    _alarmOn = json["alarmOn"];

  Alarm.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Note{alarmTime: $_alarmTime, alarmOn: $_alarmOn}';
  }
}