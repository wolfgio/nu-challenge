import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_utils.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource dataSource;
  final NetworkUtils networkUtils;

  ProductRepositoryImpl({
    required this.dataSource,
    required this.networkUtils,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (!await networkUtils.hasInternetAccess) {
      return Left(NoInternetFailure());
    }

    try {
      final products = await dataSource.getProducts();

      return Right(products!);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        code: exception.code,
        message: exception.message,
        stackTrace: exception.stackTrace,
      ));
    }
  }
}
