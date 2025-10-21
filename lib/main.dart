import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ProductController());
  Get.put(CartController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Shopsy',
    theme: ThemeData(primarySwatch: Colors.indigo),
    initialRoute: '/',
    getPages: AppRoutes.routes,
  ));
}
