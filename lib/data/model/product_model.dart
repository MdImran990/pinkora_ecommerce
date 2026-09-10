class ProductModel {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> colors;
  final List<String> sizes;
  final bool isFlashSale;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    this.images = const [],
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.colors = const [],
    this.sizes = const [],
    this.isFlashSale = false,
    this.isFeatured = false,
  });
}