import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_note_app/services/user_authentication.dart';

import 'menu_info.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key}) : super(key: key);

  void _signOut(BuildContext context) {
    try {
      context.read<AuthenticationService>().signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 20),
                ListTile(
                  title: Text('Note List'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                    // context.watch<MenuInfo>().menuType = MenuType.NoteList;
                    context.read<MenuInfo>().menuType = MenuType.NoteList;
                    print(context.read<MenuInfo>().menuType);
                  },
                ),
                ListTile(
                  title: Text('Reminder Alarms'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                    // context.watch<MenuInfo>().menuType = MenuType.AlarmList;
                    context.read<MenuInfo>().menuType = MenuType.AlarmList;
                    print(context.read<MenuInfo>().menuType);
                  },
                ),
                ListTile(
                  title: Text('Timer List'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                    // context.watch<MenuInfo>().menuType = MenuType.AlarmList;
                    context.read<MenuInfo>().menuType = MenuType.TimerList;
                    print(context.read<MenuInfo>().menuType);
                  },
                ),
                ListTile(
                  title: Text('Activity List'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                    // context.watch<MenuInfo>().menuType = MenuType.AlarmList;
                    context.read<MenuInfo>().menuType = MenuType.ActivityList;
                    print(context.read<MenuInfo>().menuType);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}