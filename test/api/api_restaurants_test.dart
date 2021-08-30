import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:http/http.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/data/model/review_restaurants.dart';
import 'package:restaurant_submissions/data/model/search_restaurants.dart';

void main() {
  group('Module API testing', () {
    ApiService apiService = ApiService();

    test('check get list restaurant', () async {
      // arrange
      apiService.client = MockClient((request) async {
        final mapJson = {
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description":
                  "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
            },
          ]
        };
        return Response(jsonEncode(mapJson), 200);
      });

      // act
      final result = await apiService.listRestaurants();

      // assert
      expect(result.error, false);
      expect(result.count, 1);
      expect(result.message, 'success');
      expect(result.restaurants.length > 0, true);
      expect(result, isA<RestaurantResult>());
      expect(result.restaurants, isA<List<Restaurants>>());
    });

    test('get detail restaurants', () async {
      // arrange
      apiService.client = MockClient((request) async {
        final mapJson = {
          "error": false,
          "message": "success",
          "restaurant": {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
            "city": "Medan",
            "address": "Jln. Pandeglang no 19",
            "pictureId": "14",
            "categories": [
              {"name": "Italia"},
              {"name": "Modern"}
            ],
            "menus": {
              "foods": [
                {"name": "Paket rosemary"},
                {"name": "Toastie salmon"}
              ],
              "drinks": [
                {"name": "Es krim"},
                {"name": "Sirup"}
              ]
            },
            "rating": 4.2,
            "customerReviews": [
              {
                "name": "Ahmad",
                "review": "Tidak rekomendasi untuk pelajar!",
                "date": "13 November 2019"
              }
            ]
          }
        };
        return Response(jsonEncode(mapJson), 200);
      });

      // act
      var result = await apiService.detailRestaurant('rqdv5juczeskfw1e867');

      // assert
      expect(result.error, false);
      expect(result.restaurant.name, 'Melting Pot');
      expect(result.restaurant.city, 'Medan');
      expect(result, isA<DetailRestaurant>());
      expect(result.restaurant, isA<Restaurant>());
    });

    test('search restaurants', () async {
      // arrange
      apiService.client = MockClient((request) async {
        final mapJson = {
          "error": false,
          "founded": 1,
          "restaurants": [
            {
              "id": "fnfn8mytkpmkfw1e867",
              "name": "Makan mudah",
              "description":
                  "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
              "pictureId": "22",
              "city": "Medan",
              "rating": 3.7
            }
          ]
        };
        return Response(jsonEncode(mapJson), 200);
      });

      // act
      var result = await apiService.searchRestaurant('Melting');

      // assert
      expect(result.error, false);
      expect(result.founded, 1);
      expect(result.restaurants.length > 0, true);
      expect(result, isA<SearchResult>());
      expect(result.restaurants[0], isA<Restaurants>());
    });

    test('add new reviews', () async {
      // arrange
      Map<String, dynamic> dataMap = {
        "id": 'idRestaurants',
        "name": 'Abdul',
        "review": 'Bagus sekali!',
      };
      apiService.client = MockClient((request) async {
        final mapJson = {
          "error": false,
          "message": "success",
          "customerReviews": [
            {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
            },
            {
              "name": "test",
              "review": "makanannya lezat",
              "date": "29 Oktober 2020"
            }
          ]
        };

        return Response(jsonEncode(mapJson), 200);
      });

      // act
      var result = await apiService.addReview(dataMap);

      // assert
      expect(result.error, false);
      expect(result.message, 'success');
      expect(result.customerReviews.length > 0, true);
      expect(result, isA<CustomerReviewResult>());
      expect(result.customerReviews, isA<List<CustomerReviews>>());
    });
  });
}
