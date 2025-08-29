// lib/main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/features/favorites/views/favorite_screen.dart';
import 'package:restoranapp/features/restaurant/views/restaurant_list_screen.dart';
import 'package:restoranapp/features/restaurant/views/widgets/custom_app_bar.dart';
import 'package:restoranapp/features/restaurant/views/widgets/custom_bottom_nav_bar.dart';
import 'package:restoranapp/features/settings/views/setting_screen.dart';
import 'package:restoranapp/main_view_model.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _pages = [
    const RestaurantListScreen(),
    const SettingsScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(),
          body: _pages[viewModel.currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: viewModel.currentIndex,
            onTap: (index) {
              viewModel.setIndex(index);
            },
          ),
        );
      },
    );
  }
}
