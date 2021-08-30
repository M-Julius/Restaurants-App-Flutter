import 'package:flutter/material.dart';
import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';

enum RestaurantDetailState { Loading, NoData, HasData, HasError }

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  /// message for response
  String _message = '';
  String get message => _message;

  /// detail results restaurant
  late DetailRestaurant _detailRestaurant;
  DetailRestaurant get resultDetail => _detailRestaurant;

  /// state detail restaurants
  RestaurantDetailState _state = RestaurantDetailState.Loading;
  RestaurantDetailState get state => _state;

  /// get detail restaurants
  Future<dynamic> fetchDetailRestaurant(String id) async {
    try {
      _state = RestaurantDetailState.Loading;
      notifyListeners();

      final detailRestaurant = await apiService.detailRestaurant(id);
      if (detailRestaurant.error) {
        _state = RestaurantDetailState.HasError;
        notifyListeners();
        return _message = detailRestaurant.message;
      } else {
        _state = RestaurantDetailState.HasData;
        notifyListeners();
        return _detailRestaurant = detailRestaurant;
      }
    } catch (e) {
      _state = RestaurantDetailState.HasError;
      notifyListeners();
      return _message = '$e';
    }
  }
}
