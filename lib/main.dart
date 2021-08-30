import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_submissions/common/navigation.dart';
import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:restaurant_submissions/data/helper/database_helper.dart';
import 'package:restaurant_submissions/data/helper/notification_helper.dart';
import 'package:restaurant_submissions/data/helper/preferences_helper.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/provider/database_provider.dart';
import 'package:restaurant_submissions/provider/detail_restaurant_provider.dart';
import 'package:restaurant_submissions/provider/list_restaurant_provider.dart';
import 'package:restaurant_submissions/provider/preference_provider.dart';
import 'package:restaurant_submissions/provider/scheduling_provider.dart';
import 'package:restaurant_submissions/ui/detail_restaurant_page.dart';
import 'package:restaurant_submissions/ui/favorite_page.dart';
import 'package:restaurant_submissions/ui/list_restaurant_page.dart';
import 'package:restaurant_submissions/ui/splash_page.dart';
import 'package:restaurant_submissions/utils/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DetailRestaurantProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferenceHelper: PreferenceHelper(
                sharedPreferences: SharedPreferences.getInstance()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, _) => MaterialApp(
          title: 'Restaurants App',
          theme: provider.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.routeName,
          navigatorKey: navigatorKey,
          routes: {
            SplashPage.routeName: (context) => SplashPage(),
            ListRestaurantPage.routeName: (context) => ListRestaurantPage(),
            DetailRestaurantPage.routeName: (context) => DetailRestaurantPage(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurants,
                ),
            FavoritePage.routeName: (context) => FavoritePage()
          },
        ),
      ),
    );
  }
}
