import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class CustomTimer {
  DateTime _timerStart;
  DateTime _timerEnd;
  String _type;
  String _description;
  final DocumentReference reference;
  
  CustomTimer({DateTime timerStart, DateTime timerEnd, String type, String description, this.reference}) {
    this._timerStart = timerStart != null ? timerStart : new DateTime.now();
    this._timerEnd = timerEnd != null ? timerEnd : new DateTime.now();
    this._type = type;
    this._description = description;
  }

  DateTime get timerStart => this._timerStart;

  set timerStart(DateTime time) {
    this._timerStart = time;
  }

  DateTime get timerEnd => this._timerEnd;

  set timerEnd(DateTime time) {
    this._timerEnd = time;
  }

  get type => this._type;

  set type(String type) {
    this._type = type;
  }

  get description => this._description;

  set description(String c) {
    this._description = c;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'timerStart': Timestamp.fromDate(this._timerStart),
      'timerEnd': Timestamp.fromDate(this._timerEnd),
      'type': this._type,
      'description': this._description
    };
  }

  CustomTimer.fromMap(Map<String, dynamic> json, {this.reference}) 
  : assert(json['timerStart'] != null),
    assert(json['timerEnd'] != null),
    this._timerStart = json["timerStart"].toDate(),
    this._timerEnd = json["timerEnd"].toDate(),
    this._type = json["type"],
    this._description = json["description"];

  CustomTimer.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Duration calculateDuration() {
    Duration duration = this.timerEnd.difference(this.timerStart);
    return duration;
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'CustomTimer{timerStart: $_timerStart, timerEnd: $_timerEnd, type: $_type, comment: $_description}';
  }
}