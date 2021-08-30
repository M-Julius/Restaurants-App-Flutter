final String baseUrl = 'https://restaurant-api.dicoding.dev';

String imageRestaurant(String type, String id) => baseUrl + '/images/$type/$id';

String imageAvatarReview(String name) =>
    'https://ui-avatars.com/api/?background=random&name=$name&size=350&rounded=true';
