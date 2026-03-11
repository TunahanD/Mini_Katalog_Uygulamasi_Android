class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.ratingRate,
    required this.ratingCount,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double ratingRate;
  final int ratingCount;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: (json['imageUrl'] ?? json['image']) as String,
      category: json['category'] as String,
      ratingRate: ((json['rating']?['rate'] ?? 0) as num).toDouble(),
      ratingCount: (json['rating']?['count'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': {
        'rate': ratingRate,
        'count': ratingCount,
      },
    };
  }
}
