import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_note_app/models/alarm.dart';
import 'package:reminder_note_app/models/note.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:reminder_note_app/pages/alarms/alarm_edit_page.dart';
import 'package:reminder_note_app/pages/notes/note_view_page.dart';
import 'package:reminder_note_app/pages/notes/note_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/services/user_authentication.dart';
import 'package:reminder_note_app/widgets/menu_drawer.dart';

class AlarmListPage extends StatefulWidget {

  const AlarmListPage({Key key}) : super(key: key);

  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {

  List<Note> notes;

  @override
  void initState() {
      super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = context.watch<FirebaseUser>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Alarms Page'),
        ),
        drawer: MenuDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreDatabaseWrapper.db.getAllAlarms(),
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
              MaterialPageRoute(builder: (context) => AlarmEditPage(new Alarm(), AlarmMode.Adding))
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
        Alarm alarm = Alarm.fromSnapshot(snapshot[index]);
        return _buildListItem(context, alarm);
      },
      itemCount: snapshot.length,
    );
  }

  Widget _buildListItem(BuildContext context, Alarm alarm) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlarmEditPage(alarm, AlarmMode.Editing))
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlarmTile(
                alarm: alarm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlarmTile extends StatefulWidget {
  final Alarm alarm;

  AlarmTile({Key key, this.alarm}) : super(key: key);

  @override
  _AlarmTileState createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.alarm.convertAlarmTimeToString()
          ),
          Switch(
            value: widget.alarm.alarmOn,
            onChanged: (value){
              setState(() {
                widget.alarm.setAlarmOn();
                FirestoreDatabaseWrapper.db.updateAlarm(widget.alarm);
                print(widget.alarm.alarmOn);
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}