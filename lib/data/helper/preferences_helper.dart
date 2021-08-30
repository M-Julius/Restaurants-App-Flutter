import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferenceHelper({required this.sharedPreferences});

  /// key
  static const DARK_THEME = 'DARK_THEME';
  static const DAILY_RESTAURANT = 'DAILY_RESTAURANT';

  /// getting current theme
  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  /// set theme
  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  /// getting daily reminder restaurants
  Future<bool> get isDailyRestaurants async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_RESTAURANT) ?? false;
  }

  /// set daily reminder restaurants
  void setDailyRestaurants(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_RESTAURANT, value);
  }
}
