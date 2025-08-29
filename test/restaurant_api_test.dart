import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restoranapp/core/api/api_service.dart';

void main() {
  test('Harus mengembalikan daftar restoran dari mock API', () async {
    // Mock client
    final client = MockClient((request) async {
      return http.Response(
        json.encode({
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "abc123",
              "name": "Mock Resto",
              "description": "Mantap",
              "pictureId": "14",
              "city": "Jakarta",
              "rating": 4.5,
            },
          ],
        }),
        200,
      );
    });

    final api = ApiService.withClient(client); // inject client
    final result = await api.getRestaurantList();

    expect(result.restaurants.isNotEmpty, true);
    expect(result.restaurants.first.name, "Mock Resto");
  });
}
