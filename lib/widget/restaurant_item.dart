import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submissions/common/navigation.dart';
import 'package:restaurant_submissions/config/config.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/provider/database_provider.dart';
import 'package:restaurant_submissions/ui/detail_restaurant_page.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurants restaurants;
  RestaurantItem({required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) => FutureBuilder<bool>(
        future: provider.isFavorited(restaurants.id),
        builder: (context, snapshot) {
          var isFavorited = snapshot.data ?? false;
          return Material(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: _leadingItem(),
              title: Text(restaurants.name),
              subtitle: _subtitleItem(context),
              trailing: IconButton(
                icon:
                    Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).primaryColor,
                onPressed: () => {
                  isFavorited
                      ? provider.removeFavorite(restaurants.id)
                      : provider.addToFavorited(restaurants)
                },
              ),
              onTap: () {
                Navigation.intentWithData(
                    DetailRestaurantPage.routeName, restaurants);
              },
            ),
          );
        },
      ),
    );
  }

  Column _subtitleItem(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.place,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            Text(restaurants.city),
          ],
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: restaurants.rating!,
              itemCount: 5,
              itemSize: 16,
              itemBuilder: (context, _) {
                return Icon(
                  Icons.star_sharp,
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
            Text(restaurants.rating.toString()),
          ],
        ),
      ],
    );
  }

  Hero _leadingItem() {
    return Hero(
      tag: restaurants.id,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Image.network(
          imageRestaurant('small', restaurants.pictureId),
          width: 110,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
