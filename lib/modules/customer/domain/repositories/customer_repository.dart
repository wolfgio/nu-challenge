import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, Customer>> getCustomer();
}
