
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

abstract class AppRoutes {
  static const splash         = '/';
  static const login          = '/login';
  static const register       = '/register';
  static const forgotPassword = '/forgot-password';
  static const home           = '/home';
  static const category       = '/category';
  static const productList    = '/product-list';
  static const productDetail  = '/product-detail';
  static const cart           = '/cart';
  static const checkout       = '/checkout';
  static const wishlist       = '/wishlist';
  static const profile        = '/profile';
}