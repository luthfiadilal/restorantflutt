import 'package:flutter/material.dart';
import 'package:restoranapp/core/database/favorite_dao.dart';
import 'package:restoranapp/features/favorites/models/favorite.dart'; // Cukup satu impor ini saja

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteDao _favoriteDao = FavoriteDao();
  List<Favorite> _favorites = [];

  List<Favorite> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    _favorites = (await _favoriteDao.readAllFavorites());
    notifyListeners();
  }

  Future<void> addFavorite(Favorite favorite) async {
    await _favoriteDao.create(favorite);
    fetchFavorites(); // Perbarui daftar setelah menambahkan
  }

  Future<void> removeFavorite(String restaurantId) async {
    await _favoriteDao.delete(restaurantId);
    fetchFavorites(); // Perbarui daftar setelah menghapus
  }

  Future<bool> isFavorite(String restaurantId) async {
    return await _favoriteDao.isFavorite(restaurantId);
  }
}
