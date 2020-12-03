import 'package:flutter/foundation.dart';

enum MenuType {
  NoteList,
  AlarmList,
  TimerList,
  ActivityList
}

class MenuInfo extends ChangeNotifier {
  MenuType _menuType;

  MenuInfo(this._menuType);

  get menuType => this._menuType;

  set menuType(MenuType menuType) {
    this._menuType = menuType;
    //Important
    notifyListeners();
  }
}