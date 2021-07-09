import 'package:dartz/dartz.dart';
import 'package:nu_challenge/features/customer/domain/repositories/customer_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';

class GetCustomerUseCase implements UseCase<Customer, NoParams> {
  final CustomerRepository repository;

  GetCustomerUseCase({required this.repository});

  @override
  Future<Either<Failure, Customer>> call(NoParams params) {
    return repository.getCustomer();
  }
}
