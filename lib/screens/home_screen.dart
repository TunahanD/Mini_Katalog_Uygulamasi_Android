import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, ProductRepository? repository})
      : repository = repository ?? const ProductRepository();

  final ProductRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Product>> _productsFuture;
  final Set<int> _cartProductIds = <int>{};
  List<String> _highlightTags = <String>[];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.repository.getProducts();
    _loadHighlightTags();
  }

  Future<void> _loadHighlightTags() async {
    final raw = await rootBundle.loadString('assets/data/highlight_tags.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    if (!mounted) {
      return;
    }
    setState(() {
      _highlightTags = decoded.map((item) => item.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final products = snapshot.data ?? <Product>[];
        final cartProducts =
            products.where((product) => _cartProductIds.contains(product.id)).toList();
        final cartTotal = cartProducts.fold<double>(
          0,
          (total, product) => total + product.price,
        );
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
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
                    children: [
                      Text(
                        'Fake Store API',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Ana Sayfa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _highlightTags.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Chip(
                        label: Text(_highlightTags[index]),
                        side: BorderSide.none,
                        backgroundColor: Colors.white,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E3A8A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sepette ${cartProducts.length} ürün',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '₺${cartTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ürünler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text('Aramaya uygun ürün bulunamadı.'))
                      : GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return ProductCard(
                              product: product,
                              isInCart: _cartProductIds.contains(product.id),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: product,
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
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
