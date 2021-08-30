import 'package:flutter/material.dart';
import 'package:restaurant_submissions/config/config.dart';
import 'package:restaurant_submissions/data/model/review_restaurants.dart';

class ReviewItem extends StatelessWidget {
  final CustomerReviews review;
  const ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Image.network(imageAvatarReview(review.name)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.name),
              Text(
                review.date,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(review.review),
          ),
        ),
        Divider(
          color: Colors.black12,
        )
      ],
    );
  }
}
