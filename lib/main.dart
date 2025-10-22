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

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopsy',

      // 🌗 Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo, // choose your color
        useMaterial3: true,
      ),

      // 🌙 Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.deepPurpleAccent,
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        useMaterial3: true,
      ),

      themeMode: ThemeMode.system,

      initialRoute: '/',
      getPages: AppRoutes.routes,
    ),
  );

}
