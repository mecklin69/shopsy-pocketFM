import 'package:get/get.dart';
import 'views/product_list_view.dart';
import 'views/product_detail_view.dart';
import 'views/cart_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => ProductListView()),
    GetPage(name: '/details', page: () => ProductDetailView()),
    GetPage(name: '/cart', page: () => CartView()),
  ];
}
