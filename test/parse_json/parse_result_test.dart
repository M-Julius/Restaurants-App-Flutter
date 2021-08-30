import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/data/model/review_restaurants.dart';
import 'package:restaurant_submissions/data/model/search_restaurants.dart';

void main() {
  group('Parse json', () {
    test('check model result restaurants', () {
      // arrange
      var sample =
          '{"error":false,"message":"success","count":20,"restaurants":[{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...","pictureId":"14","city":"Medan","rating":4.2}]}';

      // act
      var json = jsonDecode(sample);
      var result = RestaurantResult.fromJson(json);

      // assert
      expect(result.error, false);
      expect(result.restaurants.length > 0, true);
      expect(result.restaurants[0].name, 'Melting Pot');
    });

    test('check model results detail restaurants', () {
      // arrange
      var sample =
          '{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"}]},"rating":4.2,"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"}]}}';

      // act
      var json = jsonDecode(sample);
      var restaurants = DetailRestaurant.fromJson(json);

      // assert
      expect(restaurants.error, false);
      expect(restaurants.restaurant.name, 'Melting Pot');
      expect(restaurants.restaurant.city, 'Medan');
    });

    test('check model results search restaurant', () {
      // arrange
      var sample =
          '{"error":false,"founded":1,"restaurants":[{"id":"fnfn8mytkpmkfw1e867","name":"Makan mudah","description":"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...","pictureId":"22","city":"Medan","rating":3.7}]}';

      // act
      var json = jsonDecode(sample);
      var result = SearchResult.fromJson(json);

      // assert
      expect(result.founded, 1);
      expect(result.restaurants.length, 1);
    });

    test('check model results add new review', () async {
      // arrange
      var sample =
          '{"error":false,"message":"success","customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"test","review":"makanannya lezat","date":"29 Oktober 2020"}]}';

      // act
      var json = jsonDecode(sample);
      var result = CustomerReviewResult.fromJson(json);

      // assert
      expect(result.error, false);
      expect(result.message, 'success');
      expect(result.customerReviews.length > 0, true);
    });
  });
}
