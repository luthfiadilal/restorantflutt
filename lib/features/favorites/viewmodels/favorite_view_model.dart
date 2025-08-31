import 'package:flutter/material.dart';
import 'package:restoranapp/core/database/favorite_dao.dart';
import 'package:restoranapp/features/favorites/models/favorite.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteDao _favoriteDao = FavoriteDao();
  List<Favorite> _favorites = [];
  bool _isFavorite = false;

  List<Favorite> get favorites => _favorites;
  bool get isFavorite => _isFavorite;

  Future<void> fetchFavorites() async {
    _favorites = await _favoriteDao.readAllFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Favorite favorite) async {
    await _favoriteDao.create(favorite);
    await fetchFavorites();
    _isFavorite = true;
    notifyListeners();
  }

  Future<void> removeFavorite(String restaurantId) async {
    await _favoriteDao.delete(restaurantId);
    await fetchFavorites();
    _isFavorite = false;
    notifyListeners();
  }

  Future<void> checkIfFavorite(String restaurantId) async {
    _isFavorite = await _favoriteDao.isFavorite(restaurantId);
    notifyListeners();
  }

  Future<void> toggleFavorite(Favorite favorite) async {
    if (_isFavorite) {
      await removeFavorite(favorite.restaurantId);
    } else {
      await addFavorite(favorite);
    }
  }
}
