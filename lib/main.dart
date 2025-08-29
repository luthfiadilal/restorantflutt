// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/features/favorites/viewmodels/favorite_view_model.dart';
import 'package:restoranapp/features/restaurant/viewmodels/restaurant_view_model.dart';
import 'package:restoranapp/features/settings/viewmodels/reminder_view_model.dart';
import 'package:restoranapp/main_view_model.dart';

import 'features/theme/viewmodel/theme_view_model.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RestaurantViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
        ChangeNotifierProvider(create: (context) => MainScreenViewModel()),
        ChangeNotifierProvider(
          create: (_) => FavoriteViewModel(), // <-- Tambahkan ini
        ),
        ChangeNotifierProvider(create: (_) => ReminderViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Restaurant App',

            themeMode: themeViewModel.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'Manrope',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Manrope',
            ),
            home: MainScreen(),
          );
        },
      ),
    );
  }
}
