import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Factory constructor for loading from GetStorage
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // 💡 FIX: Safely access the product JSON map. If it's null, cast it as a nullable Map.
    final productJson = json['product'] as Map<String, dynamic>?;

    if (productJson == null) {
      // Return a placeholder item if the stored data is corrupted or missing the product map.
      // This prevents the application from crashing during loading.
      return CartItem(
        product: Product(
          id: 0,
          title: 'Corrupted Item (Clear Cart)',
          price: 0.0,
          image: '',
          description: '',
          category: 'Unknown',
        ),
        quantity: 0,
      );
    }

    return CartItem(
      // Pass the non-null productJson map
      product: Product.fromJson(productJson),
      quantity: json['quantity'] ?? 1,
    );
  }

  // Convert to JSON for saving to GetStorage
  Map<String, dynamic> toJson() {
    return {
      // We assume Product has a working toJson() method here.
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
