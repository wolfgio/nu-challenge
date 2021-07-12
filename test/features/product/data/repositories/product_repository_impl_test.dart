import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/exceptions.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/modules/products/data/models/product_model.dart';
import 'package:nu_challenge/modules/products/data/repositories/product_repository_impl.dart';

import '../../../../mocks/datasources_mocks.dart';
import '../../../../mocks/platform_mocks.dart';
import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductRemoteDatasourceTest, NetworkUtilsTest])
void main() {
  late MockProductRemoteDatasourceTest mockedDatasource;
  late MockNetworkUtilsTest mockedNetworkUtils;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockedDatasource = MockProductRemoteDatasourceTest();
    mockedNetworkUtils = MockNetworkUtilsTest();
    repository = ProductRepositoryImpl(
      dataSource: mockedDatasource,
      networkUtils: mockedNetworkUtils,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockedNetworkUtils.hasInternetAccess)
            .thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockedNetworkUtils.hasInternetAccess)
            .thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getProducts', () {
    runTestOnline(() {
      test(
        'Should return list of [ProductModel] when datasource successfully fetch products data',
        () async {
          final tProduct = ProductModel(
            id: faker.guid.guid(),
            name: faker.lorem.word(),
            price: faker.randomGenerator.decimal(min: 1000),
            description: faker.lorem.sentence(),
            imageUrl: faker.image.image(),
          );
          when(mockedDatasource.getProducts())
              .thenAnswer((_) async => [tProduct]);

          final products = await repository.getProducts();

          products.fold((l) => null, (r) => expect(r.first, tProduct));
          verify(mockedDatasource.getProducts()).called(1);
          verifyNoMoreInteractions(mockedDatasource);
        },
      );

      test(
        'Should return [ServerFailure] when datasource throws [ServerException]',
        () async {
          final tException = ServerException(
            message: faker.lorem.sentence(),
            code: faker.randomGenerator.integer(500, min: 400).toString(),
          );
          when(mockedDatasource.getProducts()).thenThrow(tException);

          final failure = await repository.getProducts();

          expect(
            failure,
            Left(ServerFailure(
              code: tException.code,
              message: tException.message,
            )),
          );
          verify(mockedDatasource.getProducts()).called(1);
          verifyNoMoreInteractions(mockedDatasource);
        },
      );
    });

    runTestOffline(() {
      test(
        'Should return [NoInternetFailure] when device has no connection',
        () async {
          final failure = await repository.getProducts();

          expect(failure, Left(NoInternetFailure()));
          verifyZeroInteractions(mockedDatasource);
        },
      );
    });
  });
}
