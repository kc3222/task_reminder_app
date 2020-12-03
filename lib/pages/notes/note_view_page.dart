import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:reminder_note_app/pages/notes/note_edit_page.dart';

import 'package:reminder_note_app/models/note.dart';

class NoteViewPage extends StatefulWidget {
  final DocumentReference reference;

  const NoteViewPage({Key key, @required this.reference}) : super(key: key);

  @override
  _NoteViewPageState createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {

  Stream<DocumentSnapshot> _noteStream;
  Note note;

  @override
  void initState() {
    super.initState();
    _noteStream = widget.reference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: _noteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            note = Note.fromSnapshot(snapshot.data);
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Title: " + note.title
                  ),
                  Container(height: 8,),
                  Text(
                    "Content: " + note.content
                  ),
                ],
              );
          }
        ),
        floatingActionButton: _buildCustomButtonsRow(context),
      )
    );
  }

  Widget _buildCustomButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCustomButton(onPressedFunction: () => _editNote(context), icon: Icon(Icons.edit)),
        SizedBox(width:20),
        _buildCustomButton(onPressedFunction: () => _deleteNote(context), icon: Icon(Icons.delete)),
      ],
    );
  }

  Widget _buildCustomButton({heroTag, Function onPressedFunction, Icon icon}) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressedFunction,
      child: icon,
    );
  }

  _editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(note: note, noteMode: NoteMode.Editing))
    );
  }

  void _deleteNote(BuildContext context) {
    setState(() {
      _noteStream = null;
    });
    FirestoreDatabaseWrapper.db.deleteNote(note);
    Navigator.pop(context);
  }
}