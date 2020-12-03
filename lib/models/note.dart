import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  String content;
  DateTime _date_created;
  DateTime _date_last_edited;
  final DocumentReference reference;
  
  // Note({this.id, this.title, this.content, this.date_created, this.date_last_edited, this.reference});
  Note({this.title, this.content, this.reference});

  void setDateCreated(DateTime date) {
    this._date_created = date;
  }

  void setDateEdited(DateTime date) {
    this._date_last_edited = date;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date_created': _date_created,
      'date_last_edited': _date_last_edited,
    };
  }

  Note.fromMap(Map<String, dynamic> json, {this.reference}) 
  : assert(json['title'] != null),
    assert(json['content'] != null),
    assert(json['date_created'] != null),
    assert(json['date_last_edited'] != null),
    title = json["title"],
    content = json["content"],
    _date_created = json["date_created"].toDate(),
    _date_last_edited = json["date_last_edited"].toDate();

  Note.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Note{title: $title, content: $content}';
  }
}