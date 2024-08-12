import 'package:flutter/material.dart';

class FavoritesManager extends ChangeNotifier {
  final List<FavoritesItem> _favorites = [];

  List<FavoritesItem> get favorites => _favorites;

  void addFavorite(FavoritesItem item) {
    if (!_favorites.contains(item)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFavorite(FavoritesItem item) {
    _favorites.remove(item);
    notifyListeners();
  }

  bool isFavorite(FavoritesItem item) {
    return _favorites.contains(item);
  }
}

class FavoritesItem {
  final String title;
  final String location;
  final String description;
  final String imageUrl;
  final List<String> imageUrls; // Include this field
  final double price;
  final double rating;

  FavoritesItem({
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.imageUrls, // Include this field
    required this.price,
    required this.rating,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          location == other.location &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          imageUrls == other.imageUrls && // Include this field
          price == other.price &&
          rating == other.rating;

  @override
  int get hashCode =>
      title.hashCode ^
      location.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      imageUrls.hashCode ^ // Include this field
      price.hashCode ^
      rating.hashCode;
}
