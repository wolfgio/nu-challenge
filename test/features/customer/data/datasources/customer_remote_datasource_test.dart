import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/exceptions.dart' as exceptions;
import 'package:nu_challenge/modules/customer/data/datasources/customer_remote_datasource.dart';
import 'package:nu_challenge/modules/customer/data/graphql/queries.dart';
import 'package:nu_challenge/modules/customer/data/models/customer_model.dart';

import '../../../../mocks/adapter_mocks.dart';
import 'customer_remote_datasource_test.mocks.dart';

@GenerateMocks([GraphqlAdapterTest])
void main() {
  late MockGraphqlAdapterTest mockGraphqlAdapterTest;
  late CustomerRemoteDatasourceImpl remoteDatasource;

  setUp(() {
    mockGraphqlAdapterTest = MockGraphqlAdapterTest();
    remoteDatasource = CustomerRemoteDatasourceImpl(
      graphQlAdapter: mockGraphqlAdapterTest,
    );
  });

  group('getCustomer', () {
    test(
      'Should return [CustomerModel] when adapter successfully fetch customer data',
      () async {
        final tCustomer = CustomerModel(
          id: faker.guid.guid(),
          name: faker.person.name(),
          balance: faker.randomGenerator.integer(1000).toString(),
        );
        when(mockGraphqlAdapterTest.runQuery(
          query: anyNamed('query'),
          parseData: anyNamed('parseData'),
        )).thenAnswer((_) async => Right(tCustomer));

        final customer = await remoteDatasource.getCustomer();

        expect(customer, tCustomer);
        verify(mockGraphqlAdapterTest.runQuery(
          query: getCustomerQuery,
          parseData: anyNamed('parseData'),
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );

    test(
      'Should throw [ServerException] when adapter returns any [Exception]',
      () async {
        final tGraphqlError = GraphQLError(message: faker.lorem.sentence());
        final tOperationException = OperationException(
          graphqlErrors: [tGraphqlError],
        );

        when(mockGraphqlAdapterTest.runQuery(
          query: anyNamed('query'),
          parseData: anyNamed('parseData'),
        )).thenAnswer((_) async => Left(tOperationException));

        final call = remoteDatasource.getCustomer;

        expect(
          () => call(),
          throwsA(isInstanceOf<exceptions.ServerException>()),
        );
        verify(mockGraphqlAdapterTest.runQuery(
          query: getCustomerQuery,
          parseData: anyNamed('parseData'),
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );
  });
}
