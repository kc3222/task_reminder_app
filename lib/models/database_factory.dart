import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseFactory {
  void setUID(FirebaseUser auth);

  get uid;

  get currentUser;

  // Future<void> setFireBaseUser(Future<T> user);

  get noteDatabase;

  insertNewNote(Note newNote);

  getNote(String id);

  getAllNotes({String order_by: "date_last_edited"});

  updateNote(Note newNote);

  deleteNote(Note note);

  deleteAll();

  get alarmDatabase;

  getAllAlarms({String order_by: "date_last_edited"});
}