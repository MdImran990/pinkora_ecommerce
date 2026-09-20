import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  String selectedColor;
  String selectedSize;

  /// Checked items are the ones that go to checkout.
  bool isSelected;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedColor = '',
    this.selectedSize = '',
    this.isSelected = true,
  });

  double get totalPrice => product.price * quantity;

  /// Same product with a different color/size is a different cart line.
  String get key => keyOf(product.id, selectedColor, selectedSize);

  static String keyOf(String productId, String color, String size) {
    return '$productId|$color|$size';
  }

  CartItemModel copyWith({
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'selectedColor': selectedColor,
    'selectedSize': selectedSize,
    'isSelected': isSelected,
  };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedColor: json['selectedColor']?.toString() ?? '',
      selectedSize: json['selectedSize']?.toString() ?? '',
      isSelected: json['isSelected'] != false,
    );
  }
}
