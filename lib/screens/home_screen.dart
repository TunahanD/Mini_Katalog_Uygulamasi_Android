import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _productRepository = const ProductRepository();
  final Set<int> _cartProductIds = <int>{};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = _productRepository.getProducts();
    final filteredProducts = products.where((product) {
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) {
        return true;
      }
      return product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge(
              label: Text(_cartProductIds.length.toString()),
              isLabelVisible: _cartProductIds.isNotEmpty,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.storefront, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  'Mini Katalog',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ürünleri keşfetmeye başla',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoş geldin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Bir sonraki adımda ürünleri listeleyip detay sayfasına geçişi ekleyeceğiz.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Ürün veya kategori ara',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ürünler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (filteredProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('Aramaya uygun ürün bulunamadı.'),
            ),
          ...filteredProducts.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProductCard(
                product: product,
                isInCart: _cartProductIds.contains(product.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                onAddToCart: () {
                  setState(() {
                    if (_cartProductIds.contains(product.id)) {
                      _cartProductIds.remove(product.id);
                    } else {
                      _cartProductIds.add(product.id);
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
