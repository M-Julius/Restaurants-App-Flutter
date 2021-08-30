import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:restaurant_submissions/config/config.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/data/model/review_restaurants.dart';
import 'package:restaurant_submissions/data/model/search_restaurants.dart';

class ApiService {
  Client client = Client();

  final String _messageSocketException = 'You seem to be offline.';
  final String _messageFormatException = 'Unable to process the data';

  Future<RestaurantResult> listRestaurants() async {
    try {
      final response = await client.get(Uri.parse(baseUrl + '/list'));

      if (response.statusCode == 200) {
        return RestaurantResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurant ');
      }
    } on SocketException catch (_) {
      throw SocketException(_messageSocketException);
    } on FormatException catch (_) {
      throw FormatException(_messageFormatException);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DetailRestaurant> detailRestaurant(String id) async {
    try {
      final response = await client.get(Uri.parse(baseUrl + '/detail/$id'));

      if (response.statusCode == 200) {
        return DetailRestaurant.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load info restaurant');
      }
    } on SocketException catch (_) {
      throw SocketException(_messageSocketException);
    } on FormatException catch (_) {
      throw FormatException(_messageFormatException);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<SearchResult> searchRestaurant(String query) async {
    try {
      final response = await client.get(Uri.parse(baseUrl + '/search?q=$query'));

      if (response.statusCode == 200) {
        return SearchResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurant');
      }
    } on SocketException catch (_) {
      throw SocketException(_messageSocketException);
    } on FormatException catch (_) {
      throw FormatException(_messageFormatException);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CustomerReviewResult> addReview(data) async {
    try {
      final response = await client.post(Uri.parse(baseUrl + '/review'),
          body: data,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Auth-Token": "12345"
          });

      if (response.statusCode == 200) {
        return CustomerReviewResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add review');
      }
    } on SocketException catch (_) {
      throw SocketException(_messageSocketException);
    } on FormatException catch (_) {
      throw FormatException(_messageFormatException);
    } catch (e) {
      throw Exception(e);
    }
  }
}
