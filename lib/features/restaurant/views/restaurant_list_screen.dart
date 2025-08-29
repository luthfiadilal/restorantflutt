
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_state.dart';

import '../models/restaurant_list.dart';
import '../viewmodels/restaurant_view_model.dart';
import 'widgets/restaurant_card.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantViewModel>(context, listen: false).fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantViewModel>(
      builder: (context, viewModel, child) {
        final ApiState<RestaurantListResponse> state =
        (viewModel.searchResultState is ApiSuccess<RestaurantListResponse> &&
            (viewModel.searchResultState as ApiSuccess).data.restaurants.isNotEmpty)
            ? viewModel.searchResultState
            : viewModel.restaurantListState;

        if (state is ApiLoading) {
          print('UI is in Loading state');
        } else if (state is ApiSuccess<RestaurantListResponse>) {
          print('UI is in Success state with ${state.data.restaurants.length} items');
        } else if (state is ApiError) {
          print('UI is in Error state');
        }

        return switch (state) {
          ApiLoading() => const Center(child: CircularProgressIndicator()),
          ApiSuccess<RestaurantListResponse>(data: var data) => ListView.builder(
            itemCount: data.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = data.restaurants[index];
              return RestaurantCard(restaurant: restaurant);
            },
          ),
          ApiError(message: var message) => Center(child: Text('Error: $message')),
        };
      },
    );
  }
}