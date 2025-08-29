import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoranapp/features/restaurant/models/restaurant_detail.dart';
import 'package:restoranapp/features/restaurant/models/restaurant_list.dart';




class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  factory ApiService.withClient(http.Client client) {
    return ApiService(client: client);
  }

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await client.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantListResponse> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }
}