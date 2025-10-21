import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find();

  ProductGridCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/details', arguments: product),
      borderRadius: BorderRadius.circular(5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(5),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => cartController.addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9900),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
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

class AmzCloneDrawer extends StatelessWidget {
  final ProductController productController = Get.find();

  AmzCloneDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Hello, User",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: null,
            decoration: BoxDecoration(color: Color(0xFF232F3E)),
            currentAccountPicture: Icon(Icons.account_circle, color: Colors.white, size: 50),
          ),
          ListTile(
            title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.home),
            onTap: () => Get.back(),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
            child: Text('Shop by Category',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Obx(() => Column(
            children: productController.categories.map((category) {
              return ListTile(
                title: Text(category),
                selected: productController.selectedCategory.value == category,
                selectedTileColor: Colors.amber.withOpacity(0.2),
                onTap: () {
                  productController.filterByCategory(category);
                  Get.back();
                },
              );
            }).toList(),
          )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.black54),
            title: const Text('Your Orders'),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductListView({super.key});

  PreferredSizeWidget _buildAmazonAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF232F3E),
      elevation: 0,
      toolbarHeight: 55,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 50,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Container(
        height: 40,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFF9900), width: 2),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search shopsy",
            hintStyle: TextStyle(color: Colors.black54),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'S',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Icon(Icons.search, color: Colors.black54, size: 20),
                ],
              ),
            ),
            suffixIcon: Icon(Icons.qr_code_scanner_sharp, color: Colors.grey, size: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            border: InputBorder.none,
          ),
          readOnly: true,
        ),
      ),
      actions: [
        Obx(() {
          final itemCount = cartController.totalItems;
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => Get.toNamed('/cart'),
              ),
              if (itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9900),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
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
    );
  }

  Widget _buildDeliveryBanner() {
    return Container(
      color: const Color(0xFF37475A),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              'Assignment App Shopsy-PocketFM :) - Priyanshu',
              style: TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Obx(() => Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        'Shopping in: ${productController.selectedCategory.value}',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ));
  }

  Widget _buildPromoBanner() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.card_giftcard, color: Color(0xFF00A2E8)),
              SizedBox(width: 8),
              Text(
                'Shopsy- A product of PocketFM',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF007185)),
              ),
            ],
          ),
          Text(
            'Shop Now >',
            style: TextStyle(
                color: Color(0xFF007185), fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAmazonBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 12,
      unselectedFontSize: 12,
      backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.mic_none), label: 'Microphone'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
      ],
      onTap: (index) {
        debugPrint('Bottom nav item $index tapped');
      },
      currentIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAmazonAppBar(),
      drawer: AmzCloneDrawer(),
      body: Column(
        children: [
          _buildDeliveryBanner(),
          _buildCategoryHeader(),
          _buildPromoBanner(),
          Expanded(
            child: Obx(() {
              if (productController.allProducts.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF9900)));
              }
              if (productController.displayedProducts.isEmpty) {
                return Center(
                    child: Text(
                      'No products found in the "${productController.selectedCategory.value}" category.',
                      style: const TextStyle(color: Colors.grey),
                    ));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
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
          ),
        ],
      ),
      bottomNavigationBar: _buildAmazonBottomNavBar(),
    );
  }
}
