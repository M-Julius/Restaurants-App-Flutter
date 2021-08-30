import 'package:restaurant_submissions/data/model/review_restaurants.dart';

class RestaurantResult {
  RestaurantResult({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });
  late final bool error;
  late final String message;
  late final int count;
  late final List<Restaurants> restaurants;

  RestaurantResult.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    count = json['count'];
    restaurants = List.from(json['restaurants'])
        .map((e) => Restaurants.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data["message"] = message;
    _data["count"] = count;
    _data["restaurants"] =
        List<dynamic>.from(restaurants.map((e) => e.toJson()));
    return _data;
  }
}

class Restaurants {
  Restaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });
  late final String id;
  late final String name;
  late final String description;
  late final String pictureId;
  late final String city;
  late final double? rating;

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'] == null ? 0.0 : json['rating'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['pictureId'] = pictureId;
    _data['city'] = city;
    _data['rating'] = rating;
    return _data;
  }
}

class DetailRestaurant {
  DetailRestaurant({
    required this.error,
    required this.message,
    required this.restaurant,
  });
  late final bool error;
  late final String message;
  late final Restaurant restaurant;

  DetailRestaurant.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    restaurant = Restaurant.fromJson(json['restaurant']);
  }
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });
  late final String id;
  late final String name;
  late final String description;
  late final String city;
  late final String address;
  late final String pictureId;
  late final List<Categories> categories;
  late final Menus menus;
  late final double rating;
  late final List<CustomerReviews> customerReviews;

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    city = json['city'];
    address = json['address'];
    pictureId = json['pictureId'];
    categories = List.from(json['categories'])
        .map((e) => Categories.fromJson(e))
        .toList();
    menus = Menus.fromJson(json['menus']);
    rating = json['rating'] == null ? 0.0 : json['rating'].toDouble();
    customerReviews = List.from(json['customerReviews'])
        .map((e) => CustomerReviews.fromJson(e))
        .toList();
  }
}

class Categories {
  Categories({
    required this.name,
  });
  late final String name;

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });
  late final List<Foods> foods;
  late final List<Foods> drinks;

  Menus.fromJson(Map<String, dynamic> json) {
    foods = List.from(json['foods']).map((e) => Foods.fromJson(e)).toList();
    drinks = List.from(json['drinks']).map((e) => Foods.fromJson(e)).toList();
  }
}

class Foods {
  Foods({
    required this.name,
  });
  late final String name;

  Foods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
