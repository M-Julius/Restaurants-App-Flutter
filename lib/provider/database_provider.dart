import 'package:flutter/foundation.dart';
import 'package:restaurant_submissions/data/helper/database_helper.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';

enum DatabaseState { Loading, HasData, HasError, NoData }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorited();
  }

  /// state database
  late DatabaseState _state;
  DatabaseState get state => _state;

  /// message for favorited
  String _message = '';
  String get message => _message;

  /// list favorited
  List<Restaurants> _favorited = [];
  List<Restaurants> get favorited => _favorited;

  /// get all favorited restaurant
  void _getFavorited() async {
    _favorited = await databaseHelper.getFavorites();
    if (_favorited.length > 0) {
      _state = DatabaseState.HasData;
    } else {
      _state = DatabaseState.NoData;
      _message = 'Favorited is empty!';
    }
    notifyListeners();
  }

  /// add new restaurants to favorited
  void addToFavorited(Restaurants restaurants) async {
    try {
      await databaseHelper.insertFavorite(restaurants);
      _getFavorited();
    } catch (e) {
      _state = DatabaseState.HasError;
      _message = '$e';
      notifyListeners();
    }
  }

  /// check restaurant is favorited?
  Future<bool> isFavorited(String id) async {
    final restaurant = await databaseHelper.getFavoriteById(id);
    return restaurant.isNotEmpty;
  }

  /// remove restaurant in favorite
  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorited();
    } catch (e) {
      _state = DatabaseState.HasError;
      _message = '$e';
    }
  }
}
