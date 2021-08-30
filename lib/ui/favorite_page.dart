import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submissions/provider/database_provider.dart';
import 'package:restaurant_submissions/widget/error_info.dart';
import 'package:restaurant_submissions/widget/restaurant_item.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, _) {
          if (provider.state == DatabaseState.NoData ||
              provider.state == DatabaseState.HasError) {
            /// showing message
            return ErrorInfo(message: provider.message);
          } else {
            /// showing list favorited
            var restaurants = provider.favorited;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantItem(restaurants: restaurants[index]);
              },
            );
          }
        },
      ),
    );
  }
}
