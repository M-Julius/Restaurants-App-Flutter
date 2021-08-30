import 'package:flutter/material.dart';
import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/data/model/search_restaurants.dart';

enum RestaurantState { Loading, NoData, HasData, HasError }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  /// Constructor and get all restaurant
  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  /// Result Restaurant 
  late RestaurantResult _restaurantResult;
  RestaurantResult get result => _restaurantResult;

  /// Search results 
  SearchResult _searchResult =
      SearchResult(error: false, founded: 0, restaurants: []);
  SearchResult get searchResult => _searchResult;

  /// Keyword
  String _keywordSearch = '';
  String get keywordSearch => _keywordSearch;

  /// Message for response
  String _message = '';
  String get message => _message;

  /// Restaunrants State
  late RestaurantState _restaurantState;
  RestaurantState get state => _restaurantState;


  /// for get all restaurants
  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _restaurantState = RestaurantState.Loading;
      notifyListeners();

      final listRestaurant = await apiService.listRestaurants();
      if (listRestaurant.restaurants.isEmpty) {
        _restaurantState = RestaurantState.NoData;
        notifyListeners();
        return _message = 'Restaurant Is Empty';
      } else if (listRestaurant.error) {
        _restaurantState = RestaurantState.HasError;
        notifyListeners();
        return _message = listRestaurant.message;
      } else {
        _restaurantState = RestaurantState.HasData;
        notifyListeners();
        return _restaurantResult = listRestaurant;
      }
    } catch (e) {
      _restaurantState = RestaurantState.HasError;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }

  /// for search restaurant by query
  Future<dynamic> searchRestaurant(String query) async {
    _keywordSearch = query;
    notifyListeners();
    try {
      _restaurantState = RestaurantState.Loading;
      notifyListeners();

      final listRestaurant = await apiService.searchRestaurant(query);

      if (listRestaurant.restaurants.isEmpty) {
        _restaurantState = RestaurantState.NoData;
        notifyListeners();
        return _message = 'Restaurant Is Empty';
      } else if (listRestaurant.error) {
        _restaurantState = RestaurantState.HasError;
        notifyListeners();
        return _message = 'Was Wrong';
      } else {
        _restaurantState = RestaurantState.HasData;
        notifyListeners();
        return _searchResult = listRestaurant;
      }
    } catch (e) {
      _restaurantState = RestaurantState.HasError;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
