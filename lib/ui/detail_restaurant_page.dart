import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submissions/config/config.dart';
import 'package:restaurant_submissions/data/api/api_service.dart';
import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:restaurant_submissions/data/model/review_restaurants.dart';
import 'package:restaurant_submissions/provider/database_provider.dart';
import 'package:restaurant_submissions/provider/detail_restaurant_provider.dart';
import 'package:restaurant_submissions/widget/error_info.dart';
import 'package:restaurant_submissions/widget/review_item.dart';

class DetailRestaurantPage extends StatefulWidget {
  static const routeName = '/detail_restaurant';

  final Restaurants restaurant;
  const DetailRestaurantPage({required this.restaurant});

  @override
  _DetailRestaurantPageState createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage> {
  /// scroll controller for hide shadows text
  final ScrollController _sliverScrollController = ScrollController();

  /// field add review constroller
  TextEditingController _nameText = TextEditingController();
  TextEditingController _reviewText = TextEditingController();

  double _opacityDetail = 0.0;
  bool isPinned = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    /// listen scroll controller
    _sliverScrollController.addListener(() {
      if (!isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset > kToolbarHeight) {
        setState(() {
          isPinned = true;
        });
      } else if (isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset < kToolbarHeight) {
        setState(() {
          isPinned = false;
        });
      }
    });
    onGetDetail();
  }

  @override
  void dispose() {
    _nameText.dispose();
    _reviewText.dispose();
    _sliverScrollController.dispose();
    super.dispose();
  }

  /// Get detail restaurant
  void onGetDetail() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<DetailRestaurantProvider>(context, listen: false)
          .fetchDetailRestaurant(widget.restaurant.id);
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacityDetail = 1.0;
      });
    });
  }

  /// adding new review
  void addNewReview() async {
    try {
      /// dataMap for post add review
      Map<String, dynamic> dataMap = {
        "id": widget.restaurant.id,
        "name": _nameText.text,
        "review": _reviewText.text,
      };

      /// post add review
      final response = await apiService.addReview(dataMap);

      final message = Text(
          '${response.message[0].toUpperCase()}${response.message.substring(1)} Add Review');

      if (response.message == 'success') {
        onGetDetail();
        _nameText.clear();
        _reviewText.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: message,
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: message,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _sliverScrollController,
        headerSliverBuilder: (context, bool isScrolled) {
          return [
            _buildSliverAppBar(),
          ];
        },
        body: Consumer<DetailRestaurantProvider>(
            builder: (context, restaurantDetail, _) {
          return restaurantDetail.state == RestaurantDetailState.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : restaurantDetail.state == RestaurantDetailState.HasError
                  ? ErrorInfo(message: restaurantDetail.message)
                  : restaurantDetail.state == RestaurantDetailState.HasData
                      ? _buildInfoRestaurant(
                          context, restaurantDetail.resultDetail)
                      : Center(
                          child: Text('Error ${restaurantDetail.message}'),
                        );
        }),
      ),
    );
  }

  Widget _buildInfoRestaurant(
      BuildContext context, DetailRestaurant restaurant) {
    final detail = restaurant.restaurant;
    return AnimatedOpacity(
      opacity: _opacityDetail,
      duration: Duration(milliseconds: 300),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                detail.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
              ),
              _addressAndRating(context, detail),
              SizedBox(height: 20),
              Text(detail.description),
              SizedBox(height: 20),
              _wrapChip('Categories', detail.categories),
              SizedBox(height: 20),
              _wrapChip('Menus (Foods)', detail.menus.foods),
              SizedBox(height: 20),
              _wrapChip('Menus (Drinks)', detail.menus.drinks),
              SizedBox(height: 20),
              _review(detail.customerReviews)
            ],
          ),
        ),
      ),
    );
  }

  /// Build info city, addres, rating
  Row _addressAndRating(BuildContext context, Restaurant detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.place,
              color: Theme.of(context).primaryColor,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Text(
                  '${detail.city}, ${detail.address}',
                )),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.star_sharp,
              color: Theme.of(context).primaryColor,
            ),
            Text(detail.rating.toString()),
          ],
        ),
      ],
    );
  }

  /// Build Chip in wrap with title
  Widget _wrapChip(String title, List list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: list
              .map(
                (item) => Chip(
                  label: Text(item.name),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// build review list & input
  Widget _review(List<CustomerReviews> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.headline6,
        ),
        _reviewsList(reviews),
        _reviewInput(),
      ],
    );
  }

  /// build field add new review
  Widget _reviewInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add New Reviews',
          style: Theme.of(context).textTheme.headline6,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10, top: 10),
          child: TextField(
            controller: _nameText,
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              contentPadding: EdgeInsets.all(10),
              focusColor: Colors.black38,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 10,
          ),
          child: TextField(
            controller: _reviewText,
            maxLines: 5,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: 'Reviewing',
              hintStyle: TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              contentPadding: EdgeInsets.all(10),
              focusColor: Colors.black38,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: InkWell(
            onTap: () {
              if (_nameText.text.length != 0 && _reviewText.text.length != 0) {
                addNewReview();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please complete the data'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Add Review',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
        )
      ],
    );
  }

  /// build list reviews
  Widget _reviewsList(List<CustomerReviews> reviews) {
    if (reviews.length == 0) {
      return Center(
        child: Text('Review Empty'),
      );
    }
    return Column(
      children: [
        ...reviews.map((CustomerReviews review) {
          return ReviewItem(
            review: review,
          );
        })
      ],
    );
  }

  /// Build sliver app bar
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.restaurant.name,
          style: TextStyle(
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: isPinned ? Colors.transparent : Colors.black,
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        background: Hero(
          tag: widget.restaurant.id,
          child: Image.network(
            imageRestaurant('small', widget.restaurant.pictureId),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      actions: [
        Consumer<DatabaseProvider>(
          builder: (context, provider, _) => FutureBuilder<bool>(
            future: provider.isFavorited(widget.restaurant.id),
            builder: (context, snapshot) {
              var isFavorited = snapshot.data ?? false;
              return IconButton(
                color: isPinned ? Colors.white : Theme.of(context).primaryColor,
                onPressed: () {
                  /// favorite and unfavorited restaurants
                  !isFavorited
                      ? provider.addToFavorited(widget.restaurant)
                      : provider.removeFavorite(widget.restaurant.id);
                },
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
