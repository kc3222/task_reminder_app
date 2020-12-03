import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder_note_app/models/activity.dart';
import 'package:reminder_note_app/models/database_factory.dart';

import 'alarm.dart';
import 'custom_timer.dart';
import 'note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseWrapper {

  String _uid;
  FirebaseUser _user;

  FirestoreDatabaseWrapper._();

  static final FirestoreDatabaseWrapper db = FirestoreDatabaseWrapper._();

  String note_collection_name = "notes";
  String alarm_collection_name = "alarms";
  String _timerCollectionName = "timers_db";
  String _activityCollectionName = "activities_db";

  Firestore instance = Firestore.instance;
  // CollectionReference _note_collection = Firestore.instance.collection("notes");
  // CollectionReference _alarm_collection = Firestore.instance.collection("/alarms/MQXm2Zrd4LSQQGFxvB6el01YZo72/alarms");
  CollectionReference _note_collection;
  CollectionReference _alarm_collection;
  CollectionReference _timerCollection;
  CollectionReference _activityCollection;

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  // WidgetsFlutterBinding.ensureInitialized();
  
  setUID(FirebaseUser auth) {
    db._uid = auth.uid;
    this.note_collection_name = "notes_" + auth.uid.toString();
    this.alarm_collection_name = "/alarms/" + auth.uid.toString() + "/alarms";
    this._timerCollectionName = "/timers_db/" + auth.uid.toString() + "/timers";
    this._activityCollectionName = "/activities_db/" + auth.uid.toString() + "/activities";

    this._note_collection = Firestore.instance.collection(this.note_collection_name);
    this._alarm_collection = Firestore.instance.collection(this.alarm_collection_name);
    this._timerCollection = Firestore.instance.collection(this._timerCollectionName);
    this._activityCollection = Firestore.instance.collection(this._activityCollectionName);
  }

  get uid {
    return db._uid;
  }

  Future<FirebaseUser> get currentUser async {
    return FirebaseAuth.instance.currentUser();
  }

  Future<void> setFireBaseUser(Future<FirebaseUser> currentUser) async {
    db._user = await currentUser;
    db._uid = db._user.uid;
    print('User ID: ' + db._uid);
  }

  /* 
                    Notes Collection
  */

  get noteDatabase {
    return db._note_collection;
  }

  insertNewNote(Note newNote) async {
    db._note_collection.add(newNote.toMap()).then((value) => print("Note added")).catchError((error) => print("Failed to add note: $error"));
  }

  Future<Note> getNote(String id) async {
    DocumentSnapshot snapshot = await db._note_collection.document(id).get();
    return Note.fromSnapshot(snapshot);
  }

  Stream<QuerySnapshot> getAllNotes({String order_by: "date_last_edited"}) {
    // return this._note_collection.orderBy(order_by, descending: true).snapshots();
    if (this._note_collection != null) {
      return this._note_collection.orderBy(order_by, descending: true).snapshots();
    }
    return null;
  }

  updateNote(Note newNote) async {
    newNote.reference.updateData(newNote.toMap()).then((value) => print('Note updated')).catchError((error) => print('Failed to update note: $error'));
  }

  deleteNote(Note note) async {
    if (note.reference != null) {
      return note.reference
      .delete()
      .then((value) => print("Note Deleted"))
      .catchError((error) => print("Failed to delete note: $error"));
    }
    print('Note is not in database => Cannot delete');
    return null;
  }

  deleteAll() async {
  }

  /* 
                    Alarms Collection
  */

  get alarmDatabase {
    return db._alarm_collection;
  }

  insertNewAlarm(Alarm newAlarm) async {
    db._alarm_collection.add(newAlarm.toMap()).then((value) => print("Alarm added")).catchError((error) => print("Failed to add alarm: $error"));
  }

  Future<Alarm> getAlarm(String id) async {
    DocumentSnapshot snapshot = await db._alarm_collection.document(id).get();
    return Alarm.fromSnapshot(snapshot);
  }

  Stream<QuerySnapshot> getAllAlarms({String order_by: "alarmTime"}) {
    // return this._collection.orderBy(order_by, descending: true).snapshots();
    if (this._alarm_collection != null) {
      return this._alarm_collection.snapshots();
    }
    return null;
  }

  updateAlarm(Alarm newAlarm) async {
    newAlarm.reference.updateData(newAlarm.toMap()).then((value) => print('Alarm updated')).catchError((error) => print('Failed to update alarm: $error'));
  }

  deleteAlarm(Alarm alarm) async {
    if (alarm.reference != null) {
      return alarm.reference
      .delete()
      .then((value) => print("Alarm Deleted"))
      .catchError((error) => print("Failed to delete alarm: $error"));
    }
    print('Alarm is not in database => Cannot delete');
    return null;
  }

  deleteAllAlarms() async {
  }

  /* 
                    Timers Collection
  */

  get timerDatabase {
    return db._timerCollection;
  }

  insertNewTimer(CustomTimer newTimer) async {
    db._timerCollection.add(newTimer.toMap()).then((value) => print("Timer added")).catchError((error) => print("Failed to add timer: $error"));
  }

  Future<CustomTimer> getTimer(String id) async {
    DocumentSnapshot snapshot = await db._timerCollection.document(id).get();
    return CustomTimer.fromSnapshot(snapshot);
  }

  Stream<QuerySnapshot> getAllTimers({String orderBy: "timerStart"}) {
    // return this._collection.orderBy(order_by, descending: true).snapshots();
    if (this._timerCollection != null) {
      return this._timerCollection.orderBy(orderBy, descending: true).snapshots();
    }
    return null;
  }

  updateTimer(CustomTimer newTimer) async {
    newTimer.reference.updateData(newTimer.toMap()).then((value) => print('Timer updated')).catchError((error) => print('Failed to update timer: $error'));
  }

  upsertTimer(CustomTimer timer) async {
    if (timer.reference != null) {
      timer.reference.updateData(timer.toMap()).then((value) => print('Timer updated')).catchError((error) => print('Failed to update timer: $error'));
    } else {
      db._timerCollection.add(timer.toMap()).then((value) => print("Timer added")).catchError((error) => print("Failed to add timer: $error"));
    }
  }

  deleteTimer(CustomTimer timer) async {
    if (timer.reference != null) {
      return timer.reference
      .delete()
      .then((value) => print("Timer Deleted"))
      .catchError((error) => print("Failed to delete timer: $error"));
    }
    print('Timer is not in database => Cannot delete');
    return null;
  }

  deleteAllTimers() async {
  }

  /* 
                    Activities Collection
  */

  get activityDatabase {
    return db._activityCollection;
  }

  insertNewActivity(Activity newActivity) async {
    db._activityCollection.add(newActivity.toMap()).then((value) => print("Activity added")).catchError((error) => print("Failed to add activity: $error"));
  }

  Future<Activity> getActivity(String id) async {
    DocumentSnapshot snapshot = await db._activityCollection.document(id).get();
    return Activity.fromSnapshot(snapshot);
  }

  Stream<QuerySnapshot> getAllActivities({String orderBy: "activityName"}) {
    // return this._collection.orderBy(order_by, descending: true).snapshots();
    if (this._activityCollection != null) {
      return this._activityCollection.orderBy(orderBy, descending: true).snapshots();
    }
    return null;
  }

  updateActivity(Activity newActivity) async {
    newActivity.reference.updateData(newActivity.toMap()).then((value) => print('Activity updated')).catchError((error) => print('Failed to update activity: $error'));
  }

  upsertActivity(Activity activity) async {
    if (activity.reference != null) {
      activity.reference.updateData(activity.toMap()).then((value) => print('Activity updated')).catchError((error) => print('Failed to update activity: $error'));
    } else {
      db._activityCollection.add(activity.toMap()).then((value) => print("Activity added")).catchError((error) => print("Failed to add activity: $error"));
    }
  }

  deleteActivity(Activity activity) async {
    if (activity.reference != null) {
      return activity.reference
      .delete()
      .then((value) => print("Activity Deleted"))
      .catchError((error) => print("Failed to delete activity: $error"));
    }
    print('Activity is not in database => Cannot delete');
    return null;
  }

  deleteAllActivities() async {
  }
}