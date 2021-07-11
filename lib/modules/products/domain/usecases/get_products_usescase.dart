import 'package:nu_challenge/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.getProducts();
  }
}
