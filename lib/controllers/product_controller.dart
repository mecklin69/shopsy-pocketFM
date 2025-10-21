import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  // All products loaded from the asset
  var allProducts = <Product>[].obs;
  // The list visible to the user, filtered by category
  var displayedProducts = <Product>[].obs;
  // The currently selected category
  var selectedCategory = 'All'.obs;
  // List of all unique categories
  var categories = <String>['All'].obs;

  @override
  void onInit() {
    loadProducts();
    super.onInit();
  }

  Future<void> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    allProducts.value = jsonData.map((e) => Product.fromJson(e)).toList();

    // Initialize displayedProducts with all products
    displayedProducts.value = allProducts;

    // Extract unique categories
    final productCategories = allProducts.map((p) => p.category).toSet().toList();
    categories.addAll(productCategories);
  }

  // Method to filter products based on a category
  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      displayedProducts.value = allProducts;
    } else {
      displayedProducts.value = allProducts
          .where((p) => p.category == category)
          .toList();
    }

  }
}