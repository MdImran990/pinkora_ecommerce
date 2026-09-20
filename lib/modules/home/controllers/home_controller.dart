import 'package:get/get.dart';

import '../../../data/model/category_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _repo = Get.find<ProductRepository>();

  final RxInt bannerIndex = 0.obs;

  final List<CategoryModel> categories = <CategoryModel>[];
  final List<ProductModel> flashSaleProducts = <ProductModel>[];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final allCategories = await _repo.getCategories();
    final flashSale = await _repo.getFlashSaleProducts();

    if (isClosed) return;

    categories
      ..clear()
      ..addAll(allCategories.take(5));

    flashSaleProducts
      ..clear()
      ..addAll(flashSale);

    update();
  }

  void changeBannerIndex(int index) {
    if (bannerIndex.value == index) {
      return;
    }

    bannerIndex.value = index;
  }
}
