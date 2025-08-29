import 'package:flutter_test/flutter_test.dart';
import 'package:restoranapp/core/api/api_state.dart';
import 'package:restoranapp/features/restaurant/models/restaurant_list.dart';
import 'package:restoranapp/features/restaurant/viewmodels/restaurant_view_model.dart';
import 'package:restoranapp/core/api/api_service.dart';

// Mock ApiService
class MockApiService extends ApiService {
  final bool shouldFail;

  MockApiService({this.shouldFail = false});

  @override
  Future<RestaurantListResponse> getRestaurantList() async {
    if (shouldFail) {
      throw Exception("Failed to load");
    }
    return RestaurantListResponse.fromJson({
      "error": false,
      "message": "success",
      "count": 1,
      "restaurants": [
        {
          "id": "abc123",
          "name": "Test Resto",
          "description": "Mantap",
          "pictureId": "14",
          "city": "Jakarta",
          "rating": 4.5
        }
      ]
    });
  }
}

void main() {
  group('RestaurantViewModel Test', () {
    test('State awal harus ApiLoading', () {
      final viewModel = RestaurantViewModel(apiService: MockApiService());
      expect(viewModel.restaurantListState, isA<ApiLoading>());
    });

    test('Harus mengembalikan ApiSuccess ketika getRestaurantList berhasil', () async {
      final viewModel = RestaurantViewModel(apiService: MockApiService());
      await viewModel.fetchRestaurantList();
      expect(viewModel.restaurantListState, isA<ApiSuccess<RestaurantListResponse>>());
    });

    test('Harus mengembalikan ApiError ketika getRestaurantList gagal', () async {
      final viewModel = RestaurantViewModel(apiService: MockApiService(shouldFail: true));
      await viewModel.fetchRestaurantList();
      expect(viewModel.restaurantListState, isA<ApiError>());
    });
  });
}


// Versi testable RestaurantViewModel biar bisa inject ApiService
class RestaurantViewModelTestable extends RestaurantViewModel {
  final ApiService mockApi;
  RestaurantViewModelTestable(this.mockApi);

  @override
  ApiService get apiService => mockApi;
}
