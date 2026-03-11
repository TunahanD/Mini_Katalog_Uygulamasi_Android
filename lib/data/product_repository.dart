import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductRepository {
  const ProductRepository();

  static final Uri _productsUri = Uri.parse('https://fakestoreapi.com/products');

  static const List<Map<String, dynamic>> _mockData = [
    {
      'id': 1,
      'title': 'Kablosuz Kulaklık',
      'description':
          'Günlük kullanım için hafif, uzun pil ömürlü ve gürültü azaltma destekli kulaklık.',
      'price': 1499.90,
      'imageUrl': 'https://picsum.photos/id/180/400/300',
      'category': 'Elektronik',
      'rating': {'rate': 4.6, 'count': 148},
    },
    {
      'id': 2,
      'title': 'Akıllı Saat',
      'description':
          'Nabız takibi, bildirim desteği ve spor modları ile çok amaçlı akıllı saat.',
      'price': 2199.50,
      'imageUrl': 'https://picsum.photos/id/26/400/300',
      'category': 'Giyilebilir',
      'rating': {'rate': 4.3, 'count': 89},
    },
    {
      'id': 3,
      'title': 'Mekanik Klavye',
      'description':
          'RGB aydınlatmalı, dayanıklı switch yapısına sahip oyun ve ofis klavyesi.',
      'price': 1799.00,
      'imageUrl': 'https://picsum.photos/id/0/400/300',
      'category': 'Bilgisayar',
      'rating': {'rate': 4.8, 'count': 212},
    },
    {
      'id': 4,
      'title': 'Taşınabilir Hoparlör',
      'description':
          'Su sıçramasına dayanıklı, güçlü bas performansı sunan bluetooth hoparlör.',
      'price': 999.99,
      'imageUrl': 'https://picsum.photos/id/1080/400/300',
      'category': 'Ses',
      'rating': {'rate': 4.4, 'count': 76},
    },
    {
      'id': 5,
      'title': 'Tablet Kalem',
      'description':
          'Düşük gecikmeli yazım deneyimi ve manyetik şarj desteği sunan kalem.',
      'price': 649.90,
      'imageUrl': 'https://picsum.photos/id/160/400/300',
      'category': 'Aksesuar',
      'rating': {'rate': 4.0, 'count': 53},
    },
    {
      'id': 6,
      'title': 'Oyuncu Mouse',
      'description':
          'Yüksek hassasiyetli sensör, programlanabilir tuşlar ve ergonomik tasarım.',
      'price': 799.00,
      'imageUrl': 'https://picsum.photos/id/119/400/300',
      'category': 'Bilgisayar',
      'rating': {'rate': 4.5, 'count': 132},
    },
  ];

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(_productsUri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return _mockData.map(Product.fromJson).toList();
  }
}
