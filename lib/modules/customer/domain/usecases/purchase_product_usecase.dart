import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class PurchaseProductParams extends Equatable {
  final String id;

  PurchaseProductParams(this.id);

  @override
  List<Object?> get props => [id];
}

class PurchaseProductUseCase
    implements UseCase<Customer, PurchaseProductParams> {
  final CustomerRepository repository;

  PurchaseProductUseCase({required this.repository});

  @override
  Future<Either<Failure, Customer>> call(PurchaseProductParams params) {
    return repository.purchaseProduct(id: params.id);
  }
}
