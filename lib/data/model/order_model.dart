import 'address_model.dart';
import 'cart_item_model.dart';

class OrderStatus {
  OrderStatus._();

  static const String processing = 'processing';
  static const String shipped = 'shipped';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final String couponCode;
  final AddressModel address;

  /// standard or express
  final String deliveryMethod;

  /// bkash, nagad, card or cod
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.address,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.createdAt,
    this.couponCode = '',
    this.status = OrderStatus.processing,
  });

  double get total {
    final value = subtotal + deliveryFee - discount;
    return value < 0 ? 0.0 : value;
  }

  int get itemCount {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  bool get canCancel => status == OrderStatus.processing;

  bool get isActive {
    return status == OrderStatus.processing ||
        status == OrderStatus.shipped;
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return status;
    }
  }

  String get paymentLabel {
    switch (paymentMethod) {
      case 'bkash':
        return 'bKash';
      case 'nagad':
        return 'Nagad';
      case 'card':
        return 'Card Payment';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return paymentMethod;
    }
  }

  String get deliveryLabel {
    return deliveryMethod == 'express'
        ? 'Express Delivery (1-2 days)'
        : 'Standard Delivery (3-5 days)';
  }

  OrderModel copyWith({String? status}) {
    return OrderModel(
      id: id,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      address: address,
      deliveryMethod: deliveryMethod,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      couponCode: couponCode,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'discount': discount,
    'couponCode': couponCode,
    'address': address.toJson(),
    'deliveryMethod': deliveryMethod,
    'paymentMethod': paymentMethod,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];

    return OrderModel(
      id: json['id']?.toString() ?? '',
      items: rawItems
          .map(
            (e) => CartItemModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      couponCode: json['couponCode']?.toString() ?? '',
      address: AddressModel.fromJson(
        Map<String, dynamic>.from((json['address'] as Map?) ?? const {}),
      ),
      deliveryMethod: json['deliveryMethod']?.toString() ?? 'standard',
      paymentMethod: json['paymentMethod']?.toString() ?? 'cod',
      status: json['status']?.toString() ?? OrderStatus.processing,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
