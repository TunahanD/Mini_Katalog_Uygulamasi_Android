import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/screens/home_screen.dart';

class FakeProductRepository extends ProductRepository {
  const FakeProductRepository();

  @override
  Future<List<Product>> getProducts() async {
    return const <Product>[
      Product(
        id: 1,
        title: 'Test Ürünü',
        description: 'Açıklama',
        price: 99,
        imageUrl: 'https://example.com/a.png',
        category: 'Kategori',
        ratingRate: 4.5,
        ratingCount: 20,
      ),
    ];
  }
}

void main() {
  testWidgets('Ana ekran başlığı görünür', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(repository: FakeProductRepository()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mini Katalog'), findsWidgets);
    expect(find.text('Ürünler'), findsOneWidget);
    expect(find.text('Sepette 0 ürün'), findsOneWidget);
  });
}
