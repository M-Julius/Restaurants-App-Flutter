import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_submissions/common/navigation.dart';
import 'package:restaurant_submissions/config/config.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/ui/detail_restaurant_page.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  var _channelId = "1";
  var _channelName = "channel_01";
  var _channelDescription = "restaurants daily channel";

  /// init notifications
  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    /// android setting
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// ios setting
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    /// settings initialize platform
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    /// initialize notifications
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    /// get notification in app launch details
    var details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    /// Open in background
    if (details!.didNotificationLaunchApp) {
      print('Open from background');
      await selectNotification(details.payload);
      configureSelectNotificationSubject();
    }
  }

  /// open notification selected on detail restaurant
  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload ?? 'empty payload');
  }

  /// download file
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  /// show notifications
  Future<void> showNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants restaurantResult) async {
    /// icon for notifications
    var _largeIcon = await _downloadAndSaveFile(
        imageRestaurant('large', restaurantResult.pictureId), 'largeIcon.jpg');
    var _mediumIcon = await _downloadAndSaveFile(
        imageRestaurant('small', restaurantResult.pictureId), 'mediumIcon.jpg');

    /// big picture style notifications
    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(_mediumIcon),
      largeIcon: FilePathAndroidBitmap(_largeIcon),
      contentTitle: 'Restaurant <b>${restaurantResult.name}</b>',
      htmlFormatContentTitle: true,
      summaryText: '<i>${restaurantResult.description}</i>',
      htmlFormatSummaryText: true,
    );

    /// android details notifications
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDescription,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    /// ios details notifications
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    /// initialize platform details
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    /// show up notification info
    var titleNotification = "Restaurant ${restaurantResult.name}";
    var titleRestaurants = 'Check in city ${restaurantResult.city}';

    /// showing notifications
    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleRestaurants,
      platformChannelSpecifics,
      payload: jsonEncode(restaurantResult.toJson()),
    );
  }

  /// configure stream and listen selected notification
  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var restaurant = Restaurants.fromJson(jsonDecode(payload));

        print('GOTO : ${restaurant.name}');

        Navigation.intentWithData(DetailRestaurantPage.routeName, restaurant);
      },
    );
  }
}
