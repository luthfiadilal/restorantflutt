import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/restaurant_view_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(150.0);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RestaurantViewModel>(context, listen: false);

    return AppBar(
      // Hapus toolbarHeight agar AppBar bisa lebih fleksibel
      // flexibleSpace yang dibungkus SafeArea sudah cukup
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment.end membuat konten menempel di bawah
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Hello!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const Text(
                'Restaurant List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search restaurant...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (query) {
                  viewModel.searchRestaurants(query);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
