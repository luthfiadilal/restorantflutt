final String tableFavorites = 'favorites';

class FavoriteFields {
  static final String id = '_id';
  static final String restaurantId = 'restaurantId';
  static final String name = 'name';
  static final String city = 'city';
  static final String pictureId = 'pictureId';
  static final String rating = 'rating';
}

class Favorite {
  final int? id;
  final String restaurantId;
  final String name;
  final String city;
  final String pictureId;
  final int rating;

  const Favorite({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.city,
    required this.pictureId,
    required this.rating,
  });

  Favorite copy({int? id}) => Favorite(
    id: id ?? this.id,
    restaurantId: restaurantId,
    name: name,
    city: city,
    pictureId: pictureId,
    rating: rating,
  );

  static Favorite fromJson(Map<String, Object?> json) => Favorite(
    id: json[FavoriteFields.id] as int?,
    restaurantId: json[FavoriteFields.restaurantId] as String,
    name: json[FavoriteFields.name] as String,
    city: json[FavoriteFields.city] as String,
    pictureId: json[FavoriteFields.pictureId] as String,
    rating: json[FavoriteFields.rating] as int,
  );

  Map<String, Object?> toJson() => {
    FavoriteFields.id: id,
    FavoriteFields.restaurantId: restaurantId,
    FavoriteFields.name: name,
    FavoriteFields.city: city,
    FavoriteFields.pictureId: pictureId,
    FavoriteFields.rating: rating,
  };
}
