import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/core/api/api_state.dart';
import 'package:restoranapp/features/favorites/models/favorite.dart';
import 'package:restoranapp/features/favorites/viewmodels/favorite_view_model.dart';
import 'package:restoranapp/features/restaurant/models/restaurant_detail.dart';
import 'package:restoranapp/features/restaurant/viewmodels/restaurant_view_model.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String? pictureId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.pictureId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  // Tambahkan variabel untuk status favorit
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurantViewModel = Provider.of<RestaurantViewModel>(
        context,
        listen: false,
      );
      final favoriteViewModel = Provider.of<FavoriteViewModel>(
        context,
        listen: false,
      );

      restaurantViewModel.fetchRestaurantDetail(widget.restaurantId);

      // Panggil metode untuk memeriksa status favorit
      _checkIfFavorite(favoriteViewModel);
    });
  }

  // Metode untuk memeriksa status favorit dari database
  Future<void> _checkIfFavorite(FavoriteViewModel viewModel) async {
    final bool isFav = await viewModel.isFavorite(widget.restaurantId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  // Metode untuk toggle status favorit
  void _toggleFavorite(
    FavoriteViewModel viewModel,
    RestaurantDetail restaurant,
  ) async {
    if (_isFavorite) {
      // Jika favorit, hapus dari database
      await viewModel.removeFavorite(restaurant.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restoran dihapus dari favorit')),
      );
    } else {
      // Jika bukan favorit, tambahkan ke database
      final newFavorite = Favorite(
        restaurantId: restaurant.id,
        name: restaurant.name,
        city: restaurant.city,
        pictureId: restaurant.pictureId,
        rating: restaurant.rating.toInt(),
      );
      await viewModel.addFavorite(newFavorite);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restoran ditambahkan ke favorit')),
      );
    }
    // Perbarui status favorit di UI setelah operasi selesai
    _checkIfFavorite(viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.restaurantDetailState;

          return switch (state) {
            ApiLoading() => const Center(child: CircularProgressIndicator()),
            ApiSuccess<RestaurantDetailResponse>(data: var data) =>
              _buildDetailContent(context, data.restaurant),
            ApiError(message: var message) => Center(
              child: Text('Error: $message'),
            ),
          };
        },
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    RestaurantDetail restaurant,
  ) {
    const String imageUrl =
        'https://restaurant-api.dicoding.dev/images/medium/';
    // Ambil instance FavoriteViewModel
    final favoriteViewModel = Provider.of<FavoriteViewModel>(
      context,
      listen: false,
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 250.0,
          floating: false,
          pinned: true,
          actions: [
            // Tombol favorit
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                _toggleFavorite(favoriteViewModel, restaurant);
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(restaurant.name),
            background: Hero(
              tag: 'image-${restaurant.id}',
              child: (widget.pictureId != null && widget.pictureId!.isNotEmpty)
                  ? Image.network(
                      '$imageUrl${widget.pictureId}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.city ?? ''}, ${restaurant.address}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kategori',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: restaurant.categories
                        .map((category) => Chip(label: Text(category.name)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(restaurant.description ?? ''),
                  const SizedBox(height: 16),
                  Text(
                    'Menu Makanan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildMenuList(restaurant.menus.foods),
                  const SizedBox(height: 16),
                  Text(
                    'Menu Minuman',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildMenuList(restaurant.menus.drinks),
                  const SizedBox(height: 16),
                  Text(
                    'Ulasan Pelanggan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: restaurant.customerReviews.map((review) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.name,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(review.review),
                              const SizedBox(height: 4),
                              Text(
                                review.date,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildMenuList(List<Category> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Text('- ${item.name}')).toList(),
    );
  }
}
