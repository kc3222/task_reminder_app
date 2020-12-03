import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

enum StatusMode {
  Open,
  Closed
}

class Activity {
  String _activityName;
  DateTime _dueDate;
  String _status;
  final DocumentReference reference;
  
  Activity({String activityName, DateTime dueDate, StatusMode statusMode, this.reference}) {
    this._activityName = activityName != null ? activityName : "";
    this._dueDate = dueDate != null ? dueDate : new DateTime(3000, 1, 1);
    this._status = statusMode.toString();
  }

  String get activityName => this._activityName;

  set activityName(String activityName) {
    this._activityName = activityName;
  }

  DateTime get dueDate => this._dueDate;

  set dueDate(DateTime time) {
    this._dueDate = time;
  }

  get status => this._status;

  set status(StatusMode status) {
    this._status = status.toString();
  }
  
  Map<String, dynamic> toMap() {
    return {
      'activityName': this._activityName,
      'dueDate': Timestamp.fromDate(this._dueDate),
      'status': this._status
    };
  }

  Activity.fromMap(Map<String, dynamic> json, {this.reference}) 
  : assert(json['activityName'] != null),
    assert(json['dueDate'] != null),
    assert(json['status'] != null),
    this._activityName = json["activityName"],
    this._dueDate = json["dueDate"].toDate(),
    this._status = json["status"];

  Activity.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Activity{activityName: $_activityName, dueDate: $_dueDate, status: $_status}';
  }
}