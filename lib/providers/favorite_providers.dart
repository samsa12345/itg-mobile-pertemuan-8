import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  bool isFavorite(int productId) =>
      _favorites.any((p) => p.id == productId);

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}