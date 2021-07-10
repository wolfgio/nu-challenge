import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomerUseCase implements UseCase<Customer, NoParams> {
  final CustomerRepository repository;

  GetCustomerUseCase({required this.repository});

  @override
  Future<Either<Failure, Customer>> call(NoParams params) {
    return repository.getCustomer();
  }
}
