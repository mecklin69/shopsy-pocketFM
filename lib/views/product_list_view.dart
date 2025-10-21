import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

// --- WIDGET 1: Product Grid Card ---
class ProductGridCard extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find();

  ProductGridCard(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/details', arguments: product),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Image Section
            Container(
              height: 140,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              ),
            ),

            // 🧾 Text + Price + Add button
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 5, // Smaller right padding to accommodate button
                top: 8,
                bottom: 6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.indigo, fontSize: 16),
                      ),
                      // Add to Cart Button
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart, color: Colors.indigo),
                        onPressed: () => cartController.addToCart(product),
                        tooltip: 'Add to Cart',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET 2: Side Navigation Drawer ---
class ShopsyDrawer extends StatelessWidget {
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'Browse Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Obx(() => Column(
            children: productController.categories.map((category) {
              return ListTile(
                title: Text(category, style: TextStyle(fontWeight: FontWeight.w500)),
                selected: productController.selectedCategory.value == category,
                selectedTileColor: Colors.indigo.withOpacity(0.1),
                onTap: () {
                  productController.filterByCategory(category);
                  // ✅ FIX: Close the drawer after selecting a category
                  Get.back();
                },
              );
            }).toList(),
          )),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.grey[700]),
            title: Text('About Shopsy'),
            onTap: () {
              // Handle about tap
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

// --- WIDGET 3: Main Product List View ---
class ProductListView extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show current category/filter in the title
        title: Obx(() => Text('Shopsy - ${productController.selectedCategory.value}')),
        actions: [
          Obx(() {
            // Assuming CartController now has a getter: totalItems (total count of all products)
            final itemCount = cartController.totalItems;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () =>{
                    print('navigating to cart'),
                      Get.toNamed('/cart'),}
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      drawer: ShopsyDrawer(),
      body: Obx(() {
        if (productController.allProducts.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        if (productController.displayedProducts.isEmpty) {
          return Center(
              child: Text(
                'No products found in the "${productController.selectedCategory.value}" category.',
                style: TextStyle(color: Colors.grey),
              ));
        }
        // GridView for product display
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            childAspectRatio: 0.75, // Ratio of item width to height
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productController.displayedProducts.length,
          itemBuilder: (_, index) {
            Product product = productController.displayedProducts[index];
            return ProductGridCard(product);
          },
        );
      }),
    );
  }
}
