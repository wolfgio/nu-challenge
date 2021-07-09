import 'package:dartz/dartz.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/features/customer/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, Customer>> getCustomer();
}
