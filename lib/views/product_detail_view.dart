import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

class ProductDetailView extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.image, height: 200),
            SizedBox(height: 20),
            Text(product.description),
            Spacer(),
            Text('₹${product.price}', style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => cartController.addToCart(product),
              child: Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
}
