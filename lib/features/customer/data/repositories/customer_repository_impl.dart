import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  @override
  Future<Either<Failure, Customer>> getCustomer() {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }
}
