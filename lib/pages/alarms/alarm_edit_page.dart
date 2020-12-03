import 'package:flutter/material.dart';

import 'package:reminder_note_app/models/alarm.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';

enum AlarmMode {
  Editing,
  Adding
}

class AlarmEditPage extends StatefulWidget {

  final Alarm _alarm;
  final AlarmMode _alarmMode;

  const AlarmEditPage(this._alarm, this._alarmMode, {Key key}) : super(key: key);

  @override
  _AlarmEditPageState createState() => _AlarmEditPageState();
}

class _AlarmEditPageState extends State<AlarmEditPage> {

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _hourController.text = widget._alarm.alarmTime.hour.toString();
    _minuteController.text = widget._alarm.alarmTime.minute.toString();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _hourController,
              decoration: InputDecoration(
                hintText: 'Hour'
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _minuteController,
              decoration: InputDecoration(
                hintText: 'Minute'
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
    final String hour = _hourController.text;
    final String minute = _minuteController.text;

    if(hour != '') {
      widget._alarm.alarmTime = TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
      if(widget._alarmMode == AlarmMode.Editing) await FirestoreDatabaseWrapper.db.updateAlarm(widget._alarm);
      else {
        await FirestoreDatabaseWrapper.db.insertNewAlarm(widget._alarm);
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