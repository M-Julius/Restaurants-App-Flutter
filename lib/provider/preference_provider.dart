import 'package:flutter/material.dart';
import 'package:restaurant_submissions/common/styles.dart';
import 'package:restaurant_submissions/data/helper/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferenceHelper preferenceHelper;

  /// constructor init theme & daily reminder
  PreferencesProvider({required this.preferenceHelper}) {
    _getTheme();
    _getDailyRestaurantsPreferences();
  }

  /// getting isDarktheme
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  /// getting isDailyRestaurants
  bool _isDailyRestaurantsActive = false;
  bool get isDailyRestaurantsActive => _isDailyRestaurantsActive;

  /// get theme data
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  /// get theme preferences
  void _getTheme() async {
    _isDarkTheme = await preferenceHelper.isDarkTheme;
    notifyListeners();
  }

  /// get daily preferences
  void _getDailyRestaurantsPreferences() async {
    _isDailyRestaurantsActive = await preferenceHelper.isDailyRestaurants;
    notifyListeners();
  }

  /// set theme preferences
  void enableDarkTheme(bool value) {
    preferenceHelper.setDarkTheme(value);
    _getTheme();
  }

  /// set daily reminder preferences
  void enableDailyRestaurants(bool value) {
    preferenceHelper.setDailyRestaurants(value);
    _getDailyRestaurantsPreferences();
  }
}
