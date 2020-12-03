import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/models/custom_timer.dart';
import 'package:reminder_note_app/pages/activities/activity_list_page.dart';
import 'package:reminder_note_app/pages/alarms/reminder_alarms_page.dart';

// Pages
import 'package:reminder_note_app/pages/notes/note_list_page.dart';
import 'package:reminder_note_app/pages/timer/timer_edit_page.dart';
import 'package:reminder_note_app/pages/timer/timer_list_page.dart';
import 'package:reminder_note_app/widgets/menu_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        if (value.menuType == MenuType.NoteList)
          return NoteListPage();
        else if (value.menuType == MenuType.AlarmList) 
          return AlarmListPage();
        else if (value.menuType == MenuType.TimerList)
          return TimerListPage();
        else if (value.menuType == MenuType.ActivityList)
          return ActivityListPage();
        else
          return Container(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20),
                children: <TextSpan>[
                  TextSpan(text: 'Upcoming Tutorial\n'),
                ],
              ),
            ),
          );
      }
    );
    // return TimerEditPage(new CustomTimer(), TimerMode.Adding);
  }
}