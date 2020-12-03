import 'package:flutter/material.dart';

import 'package:reminder_note_app/models/note.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';

enum NoteMode {
  Editing,
  Adding
}

class NoteEditPage extends StatefulWidget {

  final Note note;
  final NoteMode noteMode;

  const NoteEditPage({this.note, this.noteMode, Key key}) : super(key: key);

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Note title'
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Note content'
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CustomButton("Save", Colors.cyan, () {
                  save();
                  Navigator.pop(context);
                }),
                // widget.noteMode == NoteMode.Editing ?_CustomButton("Delete", Colors.cyan, () {}) : Container(),
                _CustomButton("Cancel", Colors.cyan, () {
                  Navigator.pop(context);
                }),
              ],
            )
          ]
        ),
      ),
    );
  }

  Future<void> save() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final DateTime date = DateTime.now();

    if(title != '') {
      widget.note.title = title;
      widget.note.content = content;
      widget.note.setDateEdited(date);
      if(widget.noteMode == NoteMode.Editing) await FirestoreDatabaseWrapper.db.updateNote(widget.note);
      else {
        widget.note.setDateCreated(date);
        await FirestoreDatabaseWrapper.db.insertNewNote(widget.note);
      }
    }
  }
}

class _CustomButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  const _CustomButton(this._text, this._color, this._onPressed, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 100,
      color: _color,
    );
  }
}