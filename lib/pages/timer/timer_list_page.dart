import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_note_app/models/custom_timer.dart';
import 'package:reminder_note_app/models/note.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/pages/timer/timer_edit_page.dart';
import 'package:reminder_note_app/services/user_authentication.dart';
import 'package:reminder_note_app/widgets/menu_drawer.dart';

import 'package:intl/intl.dart';

class TimerListPage extends StatefulWidget {

  const TimerListPage({Key key}) : super(key: key);

  @override
  _TimerListPageState createState() => _TimerListPageState();
}

class _TimerListPageState extends State<TimerListPage> {

  bool _isTiming = false;
  DateTime _startRecordedTime;
  DateTime _endRecordedTime;

  @override
  void initState() {
      super.initState();
  }

  void updateRecordingState(BuildContext context) {
    setState(() {
      _isTiming = !_isTiming;
    });
    if (_isTiming) {
      _startRecordedTime = DateTime.now();
    } else {
      _endRecordedTime = DateTime.now();
      print('Start Recording Time:' + _startRecordedTime.toString());
      print('End Recording Time:' + _endRecordedTime.toString());
      CustomTimer newTimer = CustomTimer(timerStart: _startRecordedTime, timerEnd: _endRecordedTime);
      _navigateToTimerEditPage(context: context, timer: newTimer, timerMode: TimerMode.Adding);
    }
  }

  void _navigateToTimerEditPage({@required BuildContext context, @required CustomTimer timer, @required TimerMode timerMode}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerEditPage(timer, timerMode))
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timer Page'),
          actions: <Widget>[
            _buildCustomInkWell(
              onPressedFunction: () {
                _navigateToTimerEditPage(
                  context: context, timer: new CustomTimer(), timerMode: TimerMode.Adding
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        drawer: MenuDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreDatabaseWrapper.db.getAllTimers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.documents);
            },
          ),
        ),
        floatingActionButton: 
          _isTiming == false ? _buildCustomButton(
            onPressedFunction: () { updateRecordingState(context); }, icon: Icon(Icons.play_arrow)
          ) : _buildCustomButton(
            onPressedFunction: () { updateRecordingState(context); }, icon: Icon(Icons.stop)
          )
      )
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        CustomTimer timer = CustomTimer.fromSnapshot(snapshot[index]);
        return _buildListItem(context, timer);
      },
      itemCount: snapshot.length,
    );
  }

  Widget _buildListItem(BuildContext context, CustomTimer timer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimerEditPage(timer, TimerMode.Editing))
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TimerPreviewTile(timer: timer,),
              ),
              SizedBox(width: 40,),
              DurationTile(duration: timer.calculateDuration())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInkWell({@required Function onPressedFunction, @required Icon icon, EdgeInsets padding = const EdgeInsets.all(16.0)}) {
    return InkWell(
      child: Container(
        padding: padding,
        child: icon
      ),
      onTap: onPressedFunction,
    );
  }

  Widget _buildCustomButton({heroTag, @required Function onPressedFunction, @required Icon icon}) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressedFunction,
      child: icon,
    );
  }
}

class TimerPreviewTile extends StatelessWidget {
  final CustomTimer timer;

  const TimerPreviewTile({this.timer, Key key}) : super(key: key);

  String formatTimerStartEnd({CustomTimer timer, bool militaryTimeMode = true}) {
    // int timerStartHour =  timer.timerStart.hour;
    // int timerStartMinute = timer.timerStart.minute;
    // int timerEndHour = timer.timerEnd.hour;
    // int timerEndMinute = timer.timerEnd.minute;
    // 24-hour mode
    if (militaryTimeMode) {
      // return timerStartHour.toString().padLeft(2, "0") + ":" + timerStartMinute.toString().padLeft(2, "0") + " - " + timerEndHour.toString().padLeft(2, "0") + ":" + timerEndMinute.toString().padLeft(2, "0");
      return DateFormat.Hm().format(timer.timerStart) + " - " + DateFormat.Hm().format(timer.timerEnd);
    }
    // 12-hour mode
    return DateFormat.jm().format(timer.timerStart).padLeft(8, "0") + " - " + DateFormat.jm().format(timer.timerEnd).padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timer.type,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.red[800],
            fontSize: 16
          )
        ),
        Text(
          formatTimerStartEnd(timer: this.timer, militaryTimeMode: false),
          style: TextStyle(
            fontSize: 16
          )
        )
      ],
    );
  }
}

class DurationTile extends StatelessWidget {
  final Duration duration;

  const DurationTile({this.duration = const Duration(hours: 0), Key key}) : super(key: key);

  String formatDuration({Duration duration}) {
    return duration.inHours.toString().padLeft(2, "0") + ":" + (duration.inMinutes - duration.inHours * 60).toString().padLeft(2, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(duration: this.duration),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold
      )
    );
  }
}