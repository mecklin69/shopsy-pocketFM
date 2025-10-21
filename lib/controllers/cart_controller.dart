// lib/controllers/cart_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
final box = GetStorage();
// 🆕 Change to use the CartItem model
var cartItems = <CartItem>[].obs;

@override
void onInit() {
super.onInit();
loadCartFromStorage();
ever(cartItems, (_) => saveCartToStorage()); // ✅ auto-save on every change
}

// 🆕 Core logic to add/increment
void addToCart(Product product) {
// 1. Check if the product is already in the cart
var existingItem = cartItems.firstWhereOrNull((item) => item.product.id == product.id);

if (existingItem != null) {
// 2. If it exists, increment the quantity and trigger update
existingItem.quantity++;
cartItems.refresh(); // Forces Obx to rebuild even if the list reference didn't change
Get.snackbar('Incremented', '${product.title} quantity increased to ${existingItem.quantity}');
} else {
// 3. If it doesn't exist, add a new CartItem
cartItems.add(CartItem(product: product, quantity: 1));
Get.snackbar('Added', '${product.title} added to cart');
}
}

// 🆕 New logic to remove/decrement
void decrementQuantity(CartItem cartItem) {
if (cartItem.quantity > 1) {
cartItem.quantity--;
cartItems.refresh();
Get.snackbar('Quantity', '${cartItem.product.title} quantity is now ${cartItem.quantity}');
} else {
// If quantity is 1, remove the whole item
removeFromCart(cartItem);
}
}

void removeFromCart(CartItem cartItem) {
cartItems.removeWhere((item) => item.product.id == cartItem.product.id);
Get.snackbar('Removed', '${cartItem.product.title} removed from cart');
}

void clearCart() {
cartItems.clear();
box.remove('cart');
Get.snackbar('Cleared', 'Cart cleared successfully');
}

// 🆕 Total calculation is now quantity * price
double get totalPrice =>
cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

int get totalItems =>
cartItems.fold(0, (sum, item) => sum + item.quantity);


// 🧠 Save to local storage (uses CartItem.toJson)
void saveCartToStorage() {
final List<Map<String, dynamic>> jsonCart =
cartItems.map((item) => item.toJson()).toList();
box.write('cart', jsonCart);
}

// 🧠 Load from local storage (uses CartItem.fromJson)
void loadCartFromStorage() {
final storedCart = box.read<List>('cart');
if (storedCart != null) {
// 🆕 Map stored JSON to CartItem
cartItems.value =
storedCart.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e))).toList();
}
}
}