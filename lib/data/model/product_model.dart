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
  final String description;

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
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'images': images,
    'price': price,
    'originalPrice': originalPrice,
    'discountPercent': discountPercent,
    'rating': rating,
    'reviewCount': reviewCount,
    'category': category,
    'colors': colors,
    'sizes': sizes,
    'isFlashSale': isFlashSale,
    'isFeatured': isFeatured,
    'description': description,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    images: List<String>.from((json['images'] as List?) ?? const []),
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
    discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    category: json['category']?.toString() ?? '',
    colors: List<String>.from((json['colors'] as List?) ?? const []),
    sizes: List<String>.from((json['sizes'] as List?) ?? const []),
    isFlashSale: json['isFlashSale'] == true,
    isFeatured: json['isFeatured'] == true,
    description: json['description']?.toString() ?? '',
  );
}
