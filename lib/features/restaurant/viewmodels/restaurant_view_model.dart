import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoranapp/core/api/api_service.dart';
import 'package:restoranapp/core/api/api_state.dart';
import 'package:restoranapp/features/restaurant/models/restaurant_detail.dart';
import 'package:restoranapp/features/restaurant/models/restaurant_list.dart';

class RestaurantViewModel extends ChangeNotifier {
  final ApiService _apiService;
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  RestaurantViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  ApiState<RestaurantListResponse> _restaurantListState = ApiLoading();
  ApiState<RestaurantDetailResponse> _restaurantDetailState = ApiLoading();
  ApiState<RestaurantListResponse> _searchResultState = ApiSuccess(
    RestaurantListResponse(
      error: false,
      message: 'success',
      founded: 0,
      restaurants: [],
    ),
  );

  Timer? _debounce; // untuk debounce search

  ApiState<RestaurantListResponse> get restaurantListState =>
      _restaurantListState;
  ApiState<RestaurantDetailResponse> get restaurantDetailState =>
      _restaurantDetailState;
  ApiState<RestaurantListResponse> get searchResultState => _searchResultState;

  Future<void> fetchRestaurantList() async {
    _restaurantListState = ApiLoading();
    notifyListeners();
    try {
      final restaurants = await _apiService.getRestaurantList();
      _restaurantListState = ApiSuccess(restaurants);
    } catch (e) {
      _restaurantListState = ApiError(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _restaurantDetailState = ApiLoading();
    notifyListeners();
    try {
      final restaurant = await _apiService.getRestaurantDetail(id);
      _restaurantDetailState = ApiSuccess(restaurant);
    } catch (e) {
      _restaurantDetailState = ApiError(e.toString());
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    _debounce?.cancel();

    if (query.isEmpty) {
      _isSearching = false; // ✅ bukan search
      _searchResultState = ApiSuccess(
        RestaurantListResponse(
          error: false,
          message: 'success',
          founded: 0,
          restaurants: [],
        ),
      );
      notifyListeners();
      return;
    }

    _isSearching = true; // ✅ lagi search
    _searchResultState = ApiLoading();
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 1500), () async {
      try {
        final result = await _apiService.searchRestaurants(query);
        _searchResultState = ApiSuccess(result);
      } catch (e) {
        _searchResultState = ApiError(e.toString());
      }
      notifyListeners();
    });
  }

}
