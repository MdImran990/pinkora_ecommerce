import 'package:get/get.dart';

import '../../../data/model/category_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _repo = Get.find<ProductRepository>();

  final RxInt bannerIndex = 0.obs;

  /// True until the first data load finishes (shows skeletons).
  bool isLoading = true;

  final List<CategoryModel> categories = <CategoryModel>[];
  final List<ProductModel> flashSaleProducts = <ProductModel>[];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    // Start both requests together so they load in parallel.
    final categoriesFuture = _repo.getCategories();
    final flashSaleFuture = _repo.getFlashSaleProducts();

    final allCategories = await categoriesFuture;
    final flashSale = await flashSaleFuture;

    if (isClosed) return;

    categories
      ..clear()
      ..addAll(allCategories.take(5));

    flashSaleProducts
      ..clear()
      ..addAll(flashSale);

    isLoading = false;

    update();
  }

  void changeBannerIndex(int index) {
    if (bannerIndex.value == index) {
      return;
    }

    bannerIndex.value = index;
  }
}
