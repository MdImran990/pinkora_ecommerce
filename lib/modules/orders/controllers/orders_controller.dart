import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../cart/controllers/cart_controller.dart';

/// Permanent controller: order history lives for the whole app session.
class OrdersController extends GetxController {
  final OrderRepository _repo = Get.find<OrderRepository>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  /// all, active, delivered or cancelled
  final RxString filter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    orders.assignAll(_repo.load());
  }

  List<OrderModel> get filtered {
    final current = filter.value;

    return orders.where((order) {
      switch (current) {
        case 'active':
          return order.isActive;
        case 'delivered':
          return order.status == OrderStatus.delivered;
        case 'cancelled':
          return order.status == OrderStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  void setFilter(String value) {
    filter.value = value;
  }

  OrderModel? byId(String id) {
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  Future<void> addOrder(OrderModel order) async {
    orders.insert(0, order);

    await _repo.save(orders.toList());
  }

  Future<void> cancelOrder(String id) async {
    final index = orders.indexWhere((order) => order.id == id);

    if (index == -1) return;

    if (!orders[index].canCancel) {
      CustomSnackbar.error(
        'Cannot Cancel',
        'This order can no longer be cancelled',
      );
      return;
    }

    orders[index] = orders[index].copyWith(status: OrderStatus.cancelled);

    await _repo.save(orders.toList());

    CustomSnackbar.success(
      'Order Cancelled',
      'Order $id has been cancelled',
    );
  }

  /// Puts all items of a past order back into the cart.
  void reorder(OrderModel order) {
    final cart = Get.find<CartController>();

    for (final item in order.items) {
      cart.addToCart(
        item.product,
        color: item.selectedColor,
        size: item.selectedSize,
        qty: item.quantity,
      );
    }

    Get.offAllNamed(AppRoutes.cart);

    CustomSnackbar.success(
      'Items Added',
      'Order items were added to your cart',
    );
  }
}
