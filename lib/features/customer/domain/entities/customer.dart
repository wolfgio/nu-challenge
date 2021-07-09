import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String balance;

  Customer({
    required this.id,
    required this.name,
    required this.balance,
  });

  @override
  List<Object?> get props => [id, name, balance];
}
