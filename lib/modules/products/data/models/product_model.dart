import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required double price,
    required String description,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl,
        );

  factory ProductModel.fromGraphQl(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Parse data to ProducModel failed');

    return ProductModel(
      id: data['id'],
      name: data['product']['name'],
      price: (data['price'] as num).toDouble(),
      description: data['product']['description'],
      imageUrl: data['product']['image'],
    );
  }
}
