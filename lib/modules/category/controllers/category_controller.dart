import 'package:get/get.dart';

import '../../../data/model/category_model.dart';
import '../../../data/repositories/product_repository.dart';

class CategoryController extends GetxController {
  final ProductRepository _repo = Get.find<ProductRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await _repo.getCategories();

    if (isClosed) return;

    categories.assignAll(result);
  }
}
