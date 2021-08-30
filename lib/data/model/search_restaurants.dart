import 'package:restaurant_submissions/data/model/restaurants.dart';

class SearchResult {
  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });
  late final bool error;
  late final int founded;
  late final List<Restaurants> restaurants;

  SearchResult.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    founded = json['founded'];
    restaurants = List.from(json['restaurants'])
        .map((e) => Restaurants.fromJson(e))
        .toList();
  }
}
