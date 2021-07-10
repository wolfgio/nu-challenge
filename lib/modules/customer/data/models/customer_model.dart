import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required String id,
    required String name,
    required String balance,
  }) : super(id: id, name: name, balance: balance);

  factory CustomerModel.fromGraphQl(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Parse data to CustomerModel failed');

    return CustomerModel(
      id: data['viewer']['id'],
      name: data['viewer']['name'],
      balance: data['viewer']['balance'],
    );
  }
}
