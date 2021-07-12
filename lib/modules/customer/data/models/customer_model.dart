import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required String id,
    required String name,
    required double balance,
  }) : super(id: id, name: name, balance: balance);

  factory CustomerModel.fromGraphQl(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Parse data to CustomerModel failed');

    return CustomerModel(
      id: data['id'],
      name: data['name'],
      balance: (data['balance'] as num).toDouble(),
    );
  }
}
