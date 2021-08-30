import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submissions/common/navigation.dart';
import 'package:restaurant_submissions/data/helper/notification_helper.dart';
import 'package:restaurant_submissions/provider/database_provider.dart';
import 'package:restaurant_submissions/provider/list_restaurant_provider.dart';
import 'package:restaurant_submissions/provider/preference_provider.dart';
import 'package:restaurant_submissions/provider/scheduling_provider.dart';
import 'package:restaurant_submissions/ui/favorite_page.dart';
import 'package:restaurant_submissions/widget/error_info.dart';
import 'package:restaurant_submissions/widget/restaurant_item.dart';
import 'package:restaurant_submissions/widget/search_field.dart';

class ListRestaurantPage extends StatefulWidget {
  static const routeName = '/list_restaurant';

  @override
  _ListRestaurantPageState createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            _appBar(context),
          ];
        },
        body: _buildList(context),
      ),
    );
  }

  /// buld drawer for constrolling theme and scheduling
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, _) => ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Restaurants App',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text('Dark Theme'),
              trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  }),
            ),
            Consumer<SchedulingProvider>(
              builder: (context, scheduling, _) => ListTile(
                title: Text('Reminder Restaurant'),
                trailing: Switch.adaptive(
                    value: provider.isDailyRestaurantsActive,
                    onChanged: (value) {
                      if (Platform.isIOS) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Coming soon!'),
                        ));
                        Navigation.back();
                      } else {
                        scheduling.setScheduledRestaurant(value);
                        provider.enableDailyRestaurants(value);
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// sliver app bar and field search
  SliverAppBar _appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu_rounded),
        iconSize: 30,
      ),
      title: Text('Restaurant App'),
      bottom: PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: SearchRestaurant(),
        ),
        preferredSize: Size.fromHeight(50.0),
      ),
      actions: [
        _buildIconFavoriteBadge(context),
      ],
    );
  }

  /// actions favorite with badge
  Widget _buildIconFavoriteBadge(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) => Stack(children: [
        IconButton(
          onPressed: () {
            Navigation.toRoute(FavoritePage.routeName);
          },
          icon: Icon(Icons.favorite),
          iconSize: 30,
        ),
        provider.favorited.length != 0
            ? Positioned(
                right: 11,
                top: 7,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${provider.favorited.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ]),
    );
  }

  /// For building list restaurant
  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == RestaurantState.Loading) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (state.state == RestaurantState.HasData) {
        /// list restaurant
        var restaurant = state.searchResult.restaurants.length != 0 &&
                state.keywordSearch.length != 0
            ? state.searchResult.restaurants
            : state.result.restaurants;

        /// Handling view all restaurant
        return ListView.builder(
          shrinkWrap: true,
          itemCount: restaurant.length,
          itemBuilder: (context, int index) {
            return RestaurantItem(
              restaurants: restaurant[index],
            );
          },
        );
      } else if (state.state == RestaurantState.NoData ||
          state.state == RestaurantState.HasError) {
        return ErrorInfo(message: state.message);
      } else {
        return Center(
          child: Text(''),
        );
      }
    });
  }
}
