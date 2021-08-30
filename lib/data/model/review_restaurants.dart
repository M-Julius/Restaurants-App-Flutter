class CustomerReviewResult {
  CustomerReviewResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });
  late final bool error;
  late final String message;
  late final List<CustomerReviews> customerReviews;

  CustomerReviewResult.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    customerReviews = List.from(json['customerReviews'])
        .map((e) => CustomerReviews.fromJson(e))
        .toList();
  }
}

class CustomerReviews {
  CustomerReviews({
    required this.name,
    required this.review,
    required this.date,
  });
  late final String name;
  late final String review;
  late final String date;

  CustomerReviews.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    review = json['review'];
    date = json['date'];
  }
}
