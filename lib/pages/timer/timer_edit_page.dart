import 'package:flutter/material.dart';

import 'package:reminder_note_app/models/alarm.dart';
import 'package:reminder_note_app/models/custom_timer.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';
import 'package:intl/intl.dart';

enum TimerMode {
  Editing,
  Adding
}

class TimerEditPage extends StatefulWidget {

  final CustomTimer _timer;
  final TimerMode _timerMode;

  const TimerEditPage(this._timer, this._timerMode, {Key key}) : super(key: key);

  @override
  _TimerEditPageState createState() => _TimerEditPageState();
}

class _TimerEditPageState extends State<TimerEditPage> {

  double _deviceHeight, _deviceWidth;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  String _typeInput, _descriptionInput;
  String _hour, _minute, _time;
  // String _setTime, _setDate;

  @override
  void initState() {
    if (widget._timer.timerStart != null) {
      _selectedStartDate = DateTime(widget._timer.timerStart.year, widget._timer.timerStart.month, widget._timer.timerStart.day);
      _selectedStartTime = TimeOfDay(hour: widget._timer.timerStart.hour, minute: widget._timer.timerStart.minute);
    }
    if (widget._timer.timerEnd != null) {
      _selectedEndDate = DateTime(widget._timer.timerEnd.year, widget._timer.timerEnd.month, widget._timer.timerEnd.day);
      _selectedEndTime = TimeOfDay(hour: widget._timer.timerEnd.hour, minute: widget._timer.timerEnd.minute);
    }
    if (widget._timer.type != null) {
      _typeInput = widget._timer.type;
    }
    if (widget._timer.description != null) {
      _descriptionInput = widget._timer.description;
    }
    // if (widget._timerMode == TimerMode.Editing) {
    //   _selectedStartDate = DateTime(widget._timer.timerStart.year, widget._timer.timerStart.month, widget._timer.timerStart.day);
    //   _selectedStartTime = TimeOfDay(hour: widget._timer.timerStart.hour, minute: widget._timer.timerStart.minute);
    //   _selectedEndDate = DateTime(widget._timer.timerEnd.year, widget._timer.timerEnd.month, widget._timer.timerEnd.day);
    //   _selectedEndTime = TimeOfDay(hour: widget._timer.timerEnd.hour, minute: widget._timer.timerEnd.minute);
    //   _typeInput = widget._timer.type;
    //   _descriptionInput = widget._timer.description;
    // }
    _startDateController.text = DateFormat.yMd().format(_selectedStartDate);
    _startTimeController.text = DateFormat.Hm().format(DateTime(2015, 1, 1, _selectedStartTime.hour, _selectedStartTime.minute));
    _endDateController.text = DateFormat.yMd().format(_selectedEndDate);
    _endTimeController.text = DateFormat.Hm().format(DateTime(2015, 1, 1, _selectedEndTime.hour, _selectedEndTime.minute));
    _typeController.text = _typeInput;
    _descriptionController.text = _descriptionInput;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Date time picker'),
        leading: _buildCustomInkWell(
          onPressedFunction: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          widget._timerMode == TimerMode.Editing ?
            _buildCustomInkWell(
              onPressedFunction: () {
                delete();
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
            )
            : Container(),
          _buildCustomInkWell(
            onPressedFunction: () {
              save();
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.check),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Start Time:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            _buildDateTimePickerRow(_selectStartDate, _selectStartTime, _startDateController, _startTimeController),
            Text(
              "End Time:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            _buildDateTimePickerRow(_selectEndDate, _selectEndTime, _endDateController, _endTimeController),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                hintText: 'Type'
              ),
            ),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLength: 200,
              maxLengthEnforced: true,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Description',
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(12)),
                //   borderSide: BorderSide(color: Colors.transparent, width: 0)
                // )
              ),
            ),
          ],
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

  Widget _buildDateTimePickerRow(Future<Null> selectDateFunction(BuildContext context),Future<Null> selectTimeFunction(BuildContext context), TextEditingController dateController, TextEditingController timeController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            // _selectStartDate(context);
            selectDateFunction(context);
          },
          child: Container(
            // width: 150,
            width: _deviceWidth / 1.57,
            // height: 100,
            // margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            // decoration: BoxDecoration(color: Colors.grey[200]),
            child: TextFormField(
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
              enabled: false,
              keyboardType: TextInputType.text,
              controller: dateController,
              onSaved: (String val) {
                // _setDate = val;
              },
              decoration: InputDecoration(
                  disabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.only(top: 0.0)),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              // _selectStartTime(context);
              selectTimeFunction(context);
            },
            child: Container(
              // margin: EdgeInsets.only(top: 30),
              // width: 150,
              width: _deviceWidth - _deviceWidth / 1.7,
              // height: _height / 9,
              alignment: Alignment.center,
              // decoration: BoxDecoration(color: Colors.grey[200]),
              child: TextFormField(
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                onSaved: (String val) {
                  // _setTime = val;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                controller: timeController,
                decoration: InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    // labelText: 'Time',
                    contentPadding: EdgeInsets.all(5)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat.yMd().format(_selectedStartDate);
        print(_selectedStartDate);
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedEndDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat.yMd().format(_selectedEndDate);
        print(_selectedEndDate);
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null)
      setState(() {
        _selectedStartTime = picked;
        _hour = _selectedStartTime.hour.toString();
        _minute = _selectedStartTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _startTimeController.text = _time;
        _startTimeController.text = DateFormat.Hm().format(DateTime(2019, 08, 1, _selectedStartTime.hour, _selectedStartTime.minute));
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null)
      setState(() {
        _selectedEndTime = picked;
        _hour = _selectedEndTime.hour.toString();
        _minute = _selectedEndTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _endTimeController.text = _time;
        _endTimeController.text = DateFormat.Hm().format(DateTime(2019, 08, 1, _selectedEndTime.hour, _selectedEndTime.minute));
      });
  }

  Future<void> delete() async {
    await FirestoreDatabaseWrapper.db.deleteTimer(widget._timer);
  }

  Future<void> save() async {
    final DateTime startDate = new DateTime(_selectedStartDate.year, _selectedStartDate.month, _selectedStartDate.day, _selectedStartTime.hour, _selectedStartTime.minute);
    final DateTime endDate = new DateTime(_selectedEndDate.year, _selectedEndDate.month, _selectedEndDate.day, _selectedEndTime.hour, _selectedEndTime.minute);
    final String type = _typeController.text;
    final String description = _descriptionController.text;

    widget._timer.timerStart = startDate;
    widget._timer.timerEnd = endDate;
    widget._timer.type = type;
    widget._timer.description = description;

    if (startDate != null) {
      // if(widget._timerMode == TimerMode.Editing) await DatabaseWrapper.db.updateTimer(widget._timer);
      // else {
      //   await DatabaseWrapper.db.insertNewTimer(widget._timer);
      // }
      await FirestoreDatabaseWrapper.db.upsertTimer(widget._timer);
    }
  }
}