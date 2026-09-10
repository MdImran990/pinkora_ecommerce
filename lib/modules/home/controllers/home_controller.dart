import 'package:get/get.dart';
import '../../../data/model/category_model.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final bannerIndex = 0.obs;

  final categories = <CategoryModel>[].obs;
  final flashSaleProducts = <ProductModel>[].obs;
  final featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    categories.value = [
      CategoryModel(id: '1', name: 'Fashion',     image: '', itemCount: 1200),
      CategoryModel(id: '2', name: 'Beauty',      image: '', itemCount: 800),
      CategoryModel(id: '3', name: 'Electronics', image: '', itemCount: 1000),
      CategoryModel(id: '4', name: 'Shoes',       image: '', itemCount: 900),
      CategoryModel(id: '5', name: 'Watches',     image: '', itemCount: 600),
    ];

    flashSaleProducts.value = [
      ProductModel(
        id: '1',
        name: 'Trendy Handbag',
        image: '',
        price: 2100,
        originalPrice: 3000,
        discountPercent: 30,
        rating: 4.8,
        reviewCount: 120,
        category: 'Fashion',
        colors: ['#FF6B9D', '#000000', '#D4A574', '#F5E6D3'],
        isFlashSale: true,
      ),
      ProductModel(
        id: '2',
        name: 'Sport Shoes',
        image: '',
        price: 3200,
        originalPrice: 4300,
        discountPercent: 25,
        rating: 4.6,
        reviewCount: 98,
        category: 'Shoes',
        isFlashSale: true,
      ),
      ProductModel(
        id: '3',
        name: 'Smart Watch',
        image: '',
        price: 4500,
        originalPrice: 7500,
        discountPercent: 40,
        rating: 4.7,
        reviewCount: 86,
        category: 'Watches',
        isFlashSale: true,
      ),
    ];
  }

  void changeBannerIndex(int index) => bannerIndex.value = index;
  void changeTab(int index) => currentIndex.value = index;
}