import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_note_app/models/note.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:reminder_note_app/pages/notes/note_view_page.dart';
import 'package:reminder_note_app/pages/notes/note_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/services/user_authentication.dart';
import 'package:reminder_note_app/widgets/menu_drawer.dart';

class NoteListPage extends StatefulWidget {

  const NoteListPage({Key key}) : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  List<Note> notes;

  @override
  void initState() {
      super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        drawer: MenuDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: StreamBuilder<QuerySnapshot>(
            // stream: FirestoreDatabaseWrapper.db.database.snapshots(),
            stream: FirestoreDatabaseWrapper.db.getAllNotes(),
            // stream: Firestore.instance.collection('notes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.documents);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteEditPage(note: new Note(), noteMode: NoteMode.Adding))
            );
          },
          child: Icon(Icons.add),
        ),
      )
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Note note = Note.fromSnapshot(snapshot[index]);
        return _buildListItem(context, note);
      },
      itemCount: snapshot.length,
    );
  }

  Widget _buildListItem(BuildContext context, Note note) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteViewPage(reference: note.reference))
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NoteTitle(
                title: note.title
              ),
              Container(height: 4,),
              NoteContent(
                content: note.content
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteTitle extends StatelessWidget {
  NoteTitle({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
        ),
    );
  }
}

class NoteContent extends StatelessWidget {
  NoteContent({Key key, this.content}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      this.content,
      style: TextStyle(color: Colors.grey),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}