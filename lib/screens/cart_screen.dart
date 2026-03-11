import 'package:flutter/material.dart';

import '../models/product.dart';

class CartScreenArgs {
  const CartScreenArgs({
    required this.products,
    required this.initialCartProductIds,
    required this.onToggleCart,
  });

  final List<Product> products;
  final Set<int> initialCartProductIds;
  final ValueChanged<int> onToggleCart;
}

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.products,
    required this.initialCartProductIds,
    required this.onToggleCart,
  });

  final List<Product> products;
  final Set<int> initialCartProductIds;
  final ValueChanged<int> onToggleCart;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final Set<int> _cartIds;

  @override
  void initState() {
    super.initState();
    _cartIds = Set<int>.from(widget.initialCartProductIds);
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts =
        widget.products.where((product) => _cartIds.contains(product.id)).toList();
    final total = cartProducts.fold<double>(
      0,
      (value, product) => value + product.price,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (cartProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.remove_shopping_cart_outlined,
                        size: 56,
                        color: Colors.black45,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Sepetiniz boş',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ürünlere geri dön'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: cartProducts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFEFF2FF),
                          child: Text(product.id.toString()),
                        ),
                        title: Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('₺${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              _cartIds.remove(product.id);
                            });
                            widget.onToggleCart(product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text(
                    'Toplam',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '₺${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A8A),
                    ),
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
