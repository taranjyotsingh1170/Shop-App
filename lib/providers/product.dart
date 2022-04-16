import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
    required this.price,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url =
        'https://taran-750ab-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(                            
        Uri.parse(url),
        body: json.encode(
          isFavorite
        //   {
        //   'isFavorite': isFavorite,                        // Used it in Patch request
        // }
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
