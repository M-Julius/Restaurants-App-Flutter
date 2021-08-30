import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_submissions/data/helper/date_time_helper.dart';
import 'package:restaurant_submissions/utils/background_service.dart';

class SchedulingProvider extends ChangeNotifier {
  int _idAlarmManager = 1;

  /// scheduling status
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  /// set scheduling reminder
  Future<bool> setScheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('------- Actived Scheduling');
      print("DATE NOW NOTIF : ${DateTimeHelper.format()}");
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(days: 1),
        _idAlarmManager,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('------ Scheduling Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(_idAlarmManager);
    }
  }
}
