import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/features/favorites/viewmodels/favorite_view_model.dart';
import 'package:restoranapp/features/favorites/views/favorite_list_item.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchFavorites() saat halaman pertama kali dimuat
    Provider.of<FavoriteViewModel>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restoran Favorit')),
      body: Consumer<FavoriteViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.favorites.isEmpty) {
            return Center(child: Text('Belum ada restoran favorit.'));
          }
          return ListView.builder(
            itemCount: viewModel.favorites.length,
            itemBuilder: (context, index) {
              final favorite = viewModel.favorites[index];
              return FavoriteListItem(favorite: favorite);
            },
          );
        },
      ),
    );
  }
}
