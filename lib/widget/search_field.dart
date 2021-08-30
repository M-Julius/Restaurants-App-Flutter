import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submissions/provider/list_restaurant_provider.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  _SearchRestaurantState createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onSearch(String text) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .searchRestaurant(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => onSearch(value),
                controller: _searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  focusColor: Colors.black,
                  fillColor: Colors.black,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            _searchController.text.trim().isEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    onPressed: null,
                  )
                : IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                      onSearch('');
                    },
                  )
          ],
        ),
      ),
      width: 350,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
              color: Colors.green.withOpacity(0.23),
            )
          ]),
    );
  }
}
