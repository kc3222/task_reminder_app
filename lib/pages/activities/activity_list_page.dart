import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_note_app/models/activity.dart';
import 'package:reminder_note_app/models/note.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:reminder_note_app/pages/notes/note_view_page.dart';
import 'package:reminder_note_app/pages/notes/note_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/services/user_authentication.dart';
import 'package:reminder_note_app/widgets/menu_drawer.dart';

class ActivityListPage extends StatefulWidget {

  const ActivityListPage({Key key}) : super(key: key);

  @override
  _ActivityListPageState createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {

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
            // stream: DatabaseWrapper.db.database.snapshots(),
            stream: FirestoreDatabaseWrapper.db.getAllActivities(),
            // stream: Firestore.instance.collection('notes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.documents);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => NoteEditPage(note: new Note(), noteMode: NoteMode.Adding))
            // );
          },
          child: Icon(Icons.add),
        ),
      )
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Activity activity = Activity.fromSnapshot(snapshot[index]);
        return _buildListItem(context, activity);
      },
      itemCount: snapshot.length,
    );
  }

  Widget _buildListItem(BuildContext context, Activity activity) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => NoteViewPage(reference: activity.reference))
        // );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ActivityTile(
                activityName: activity.activityName
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  ActivityTile({Key key, this.activityName}) : super(key: key);

  final String activityName;

  @override
  Widget build(BuildContext context) {
    return Text(
      this.activityName,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
        ),
    );
  }
}