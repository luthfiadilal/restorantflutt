import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/features/favorites/models/favorite.dart';
import 'package:restoranapp/features/favorites/viewmodels/favorite_view_model.dart';
import 'package:restoranapp/features/restaurant/views/restaurant_detail_screen.dart';

class FavoriteListItem extends StatelessWidget {
  final Favorite favorite;

  const FavoriteListItem({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    const String imageUrl = 'https://restaurant-api.dicoding.dev/images/small/';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                restaurantId: favorite.restaurantId,
                restaurantName: favorite.name,
                pictureId: favorite.pictureId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Gambar restoran dengan Hero
              Hero(
                tag: 'image-${favorite.restaurantId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    '$imageUrl${favorite.pictureId}',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(favorite.city),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(favorite.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              // Tombol untuk menghapus dari favorit
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Panggil metode untuk menghapus dari ViewModel
                  Provider.of<FavoriteViewModel>(
                    context,
                    listen: false,
                  ).removeFavorite(favorite.restaurantId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Restoran dihapus dari favorit'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
