import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_utils.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDatasource dataSource;
  final NetworkUtils networkUtils;

  CustomerRepositoryImpl({
    required this.dataSource,
    required this.networkUtils,
  });

  @override
  Future<Either<Failure, Customer>> getCustomer() async {
    if (!await networkUtils.hasInternetAccess) {
      return Left(NoInternetFailure());
    }

    try {
      final customer = await dataSource.getCustomer();

      return Right(customer!);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        code: exception.code,
        message: exception.message,
        stackTrace: exception.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Customer>> purchaseProduct({
    required String id,
  }) async {
    if (!await networkUtils.hasInternetAccess) {
      return Left(NoInternetFailure());
    }

    try {
      final customer = await dataSource.purchaseProduct(id: id);

      return Right(customer!);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        code: exception.code,
        message: exception.message,
        stackTrace: exception.stackTrace,
      ));
    }
  }
}
