import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final double price;
  final String name;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.price,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, price, name, description, imageUrl];
}
