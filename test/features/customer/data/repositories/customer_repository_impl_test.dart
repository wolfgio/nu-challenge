import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/exceptions.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/features/customer/data/models/customer_model.dart';
import 'package:nu_challenge/features/customer/data/repositories/customer_repository_impl.dart';

import '../../../../mocks/datasources_mocks.dart';
import '../../../../mocks/platform_mocks.dart';
import 'customer_repository_impl_test.mocks.dart';

@GenerateMocks([CustomerRemoteDatasourceTest, NetworkUtilsTest])
void main() {
  late MockCustomerRemoteDatasourceTest mockedDatasource;
  late MockNetworkUtilsTest mockedNetworkUtils;
  late CustomerRepositoryImpl repository;

  setUp(() {
    mockedDatasource = MockCustomerRemoteDatasourceTest();
    mockedNetworkUtils = MockNetworkUtilsTest();
    repository = CustomerRepositoryImpl(
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

  group('getCustomer', () {
    runTestOnline(() {
      test(
        'Should return [CustomerModel] when datasource successfully fetch customer data',
        () async {
          final tCustomerModel = CustomerModel(
            id: faker.guid.guid(),
            name: faker.person.name(),
            balance: faker.randomGenerator.integer(1000).toString(),
          );
          when(mockedDatasource.getCustomer())
              .thenAnswer((_) async => tCustomerModel);

          final customer = await repository.getCustomer();

          expect(customer, Right(tCustomerModel));
          verify(mockedDatasource.getCustomer()).called(1);
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
          when(mockedDatasource.getCustomer()).thenThrow(tException);

          final failure = await repository.getCustomer();

          expect(
            failure,
            Left(ServerFailure(
              code: tException.code,
              message: tException.message,
            )),
          );
          verify(mockedDatasource.getCustomer()).called(1);
          verifyNoMoreInteractions(mockedDatasource);
        },
      );
    });

    runTestOffline(() {
      test(
        'Should return [NoInternetFailure] when device has no connection',
        () async {
          final failure = await repository.getCustomer();

          expect(failure, Left(NoInternetFailure()));
          verifyZeroInteractions(mockedDatasource);
        },
      );
    });
  });
}
