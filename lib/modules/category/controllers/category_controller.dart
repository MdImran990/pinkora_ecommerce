import 'package:get/get.dart';
import '../../../data/model/category_model.dart';

class CategoryController extends GetxController {
  final categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = [
      CategoryModel(id: '1', name: 'Fashion',       image: '', itemCount: 1200),
      CategoryModel(id: '2', name: 'Beauty',        image: '', itemCount: 800),
      CategoryModel(id: '3', name: 'Electronics',   image: '', itemCount: 1000),
      CategoryModel(id: '4', name: 'Shoes',         image: '', itemCount: 900),
      CategoryModel(id: '5', name: 'Watches',       image: '', itemCount: 600),
      CategoryModel(id: '6', name: 'Bags',          image: '', itemCount: 500),
      CategoryModel(id: '7', name: 'Accessories',   image: '', itemCount: 400),
      CategoryModel(id: '8', name: 'Home & Living', image: '', itemCount: 700),
    ];
  }
}