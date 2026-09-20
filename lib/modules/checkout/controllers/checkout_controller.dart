import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../data/model/address_model.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/order_model.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../address/controllers/address_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../orders/controllers/orders_controller.dart';

class CheckoutController extends GetxController {
  final CartController _cart = Get.find<CartController>();
  final AddressController _addresses = Get.find<AddressController>();
  final OrdersController _orders = Get.find<OrdersController>();
  final NotificationController _notifications =
  Get.find<NotificationController>();

  final RxInt currentStep = 0.obs;

  // Address
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();

  RxList<AddressModel> get addresses => _addresses.addresses;

  // Delivery
  final RxString selectedDelivery = 'standard'.obs;

  static const double standardFee = 80.0;
  static const double expressFee = 150.0;

  // Payment
  final RxString selectedPayment = 'bkash'.obs;

  final RxBool isPlacing = false.obs;

  // Order values (come from the cart: checked items only)
  List<CartItemModel> get items => _cart.selectedItems;

  // While an order is being placed the cart is emptied; the totals shown on
  // screen are frozen so they do not flash to zero during the transition.
  double? _lockedSubtotal;
  double? _lockedDiscount;

  double get subtotal => _lockedSubtotal ?? _cart.subtotal;

  double get discount => _lockedDiscount ?? _cart.discountAmount;

  double get deliveryFee {
    return selectedDelivery.value == 'standard'
        ? standardFee
        : expressFee;
  }

  double get total {
    final value = subtotal + deliveryFee - discount;
    return value < 0 ? 0.0 : value;
  }

  @override
  void onInit() {
    super.onInit();

    selectedAddress.value = _addresses.defaultAddress;

    final savedPayment =
    GetStorage().read<String>(StorageKeys.defaultPayment);

    if (savedPayment != null && savedPayment.isNotEmpty) {
      selectedPayment.value = savedPayment;
    }
  }

  // ── Steps ──

  void nextStep() {
    final step = currentStep.value;

    if (step >= 3) return;

    if (step == 0 && selectedAddress.value == null) {
      CustomSnackbar.error(
        'Address Required',
        'Please add or select a shipping address',
      );
      return;
    }

    currentStep.value = step + 1;
  }

  void previousStep() {
    final step = currentStep.value;

    if (step <= 0) return;

    currentStep.value = step - 1;
  }

  /// App-bar back button: previous step, or leave checkout on the first step.
  void handleBack() {
    if (currentStep.value > 0) {
      previousStep();
    } else {
      Get.back();
    }
  }

  // ── Address ──

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> addNewAddress() async {
    final result = await Get.toNamed(AppRoutes.addressForm);

    if (result is AddressModel) {
      selectedAddress.value = result;
    }
  }

  // ── Delivery / payment ──

  void selectDelivery(String type) {
    if (selectedDelivery.value == type) return;

    selectedDelivery.value = type;
  }

  void selectPayment(String method) {
    if (selectedPayment.value == method) return;

    selectedPayment.value = method;
  }

  // ── Place order ──

  String _newOrderId() {
    final stamp = DateTime.now().millisecondsSinceEpoch.toString();

    return 'PK${stamp.substring(stamp.length - 7)}';
  }

  Future<void> placeOrder() async {
    if (isPlacing.value) return;

    final address = selectedAddress.value;
    final orderItems = items.map((item) => item.copyWith()).toList();

    if (address == null) {
      currentStep.value = 0;

      CustomSnackbar.error(
        'Address Required',
        'Please add or select a shipping address',
      );
      return;
    }

    if (orderItems.isEmpty) {
      CustomSnackbar.error(
        'Nothing to Order',
        'Select at least one item in your cart',
      );
      return;
    }

    isPlacing.value = true;

    _lockedSubtotal = subtotal;
    _lockedDiscount = discount;

    try {
      // Small delay to mimic a network call.
      await Future.delayed(const Duration(milliseconds: 900));

      final order = OrderModel(
        id: _newOrderId(),
        items: orderItems,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        couponCode: _cart.couponCode.value,
        address: address,
        deliveryMethod: selectedDelivery.value,
        paymentMethod: selectedPayment.value,
        createdAt: DateTime.now(),
      );

      await _orders.addOrder(order);

      Get.offAllNamed(
        AppRoutes.orderSuccess,
        arguments: order,
      );

      _cart.removeSelected();

      await _notifications.add(
        title: 'Order Placed 🎉',
        body: 'Your order ${order.id} has been placed successfully.',
        type: 'order',
      );
    } catch (_) {
      _lockedSubtotal = null;
      _lockedDiscount = null;
      isPlacing.value = false;

      CustomSnackbar.error(
        'Order Failed',
        'Something went wrong. Please try again.',
      );
    }
  }
}
