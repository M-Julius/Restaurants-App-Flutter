import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:restaurant_submissions/data/helper/notification_helper.dart';
import 'package:restaurant_submissions/main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createJob();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createJob();
    }
    return _service!;
  }

  /// initialize isolate
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  /// callback daily reminder 
  static Future<void> callback() async {
    print('Notification New!');

    final NotificationHelper _notificationHelper = NotificationHelper();

    /// getting all restaurants
    var results = await ApiService().listRestaurants();
    final resResult = results.restaurants;

    /// get random restaurants results
    var restaurants = resResult[new Random().nextInt(resResult.length)];

    print("RANDOM RESTAURANTS : ${restaurants.name}");

    await _notificationHelper.showNotifications(
        flutterLocalNotificationsPlugin, restaurants);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
