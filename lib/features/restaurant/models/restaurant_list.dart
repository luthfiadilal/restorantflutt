import 'dart:convert';

RestaurantListResponse restaurantListResponseFromJson(String str) =>
    RestaurantListResponse.fromJson(json.decode(str));

String restaurantListResponseToJson(RestaurantListResponse data) =>
    json.encode(data.toJson());

class RestaurantListResponse {
  bool error;
  String message;
  int? count;
  int? founded;
  List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    this.count,
    this.founded,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantListResponse(
        error: json["error"] ?? false,
        message: json["message"] ?? '',
        count: json["count"],
        founded: json["founded"],
        restaurants: json["restaurants"] != null
            ? List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "founded": founded,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class Restaurant {
  String id;
  String name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"] != null ? (json["rating"] as num).toDouble() : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}
