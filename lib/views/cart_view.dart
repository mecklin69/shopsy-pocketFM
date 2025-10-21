// lib/views/cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';

class CartView extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 🆕 Display total count of items (not unique products)
        title: Obx(() => Text('Your Cart (${cartController.totalItems})')),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => cartController.clearCart(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('Cart is empty'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (_, index) {
                  CartItem cartItem = cartController.cartItems[index]; // 🆕 Use CartItem

                  return ListTile(
                    leading: Image.network(cartItem.product.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(cartItem.product.title),
                    // 🆕 Display item price and subtotal
                    subtitle: Text(
                        'Price: ₹${cartItem.product.price.toStringAsFixed(0)} | Subtotal: ₹${(cartItem.product.price * cartItem.quantity).toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Decrement Button
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => cartController.decrementQuantity(cartItem),
                        ),
                        // Quantity Display
                        Text('${cartItem.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        // Increment Button
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => cartController.addToCart(cartItem.product),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // ... (Total and Checkout Button)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: ₹${cartController.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Checkout'),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}