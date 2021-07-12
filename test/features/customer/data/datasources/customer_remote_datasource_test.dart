import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/exceptions.dart' as exceptions;
import 'package:nu_challenge/modules/customer/data/datasources/customer_remote_datasource.dart';
import 'package:nu_challenge/modules/customer/data/graphql/mutations.dart';
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
          balance: faker.randomGenerator.decimal(min: 1000),
        );
        when(mockGraphqlAdapterTest.runQuery(
          query: anyNamed('query'),
          parseData: anyNamed('parseData'),
          fetchPolicy: FetchPolicy.networkOnly,
        )).thenAnswer((_) async => Right(tCustomer));

        final customer = await remoteDatasource.getCustomer();

        expect(customer, tCustomer);
        verify(mockGraphqlAdapterTest.runQuery(
          query: getCustomerQuery,
          parseData: anyNamed('parseData'),
          fetchPolicy: FetchPolicy.networkOnly,
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
          fetchPolicy: anyNamed('fetchPolicy'),
        )).thenAnswer((_) async => Left(tOperationException));

        final call = remoteDatasource.getCustomer;

        expect(
          () => call(),
          throwsA(isInstanceOf<exceptions.ServerException>()),
        );
        verify(mockGraphqlAdapterTest.runQuery(
          query: getCustomerQuery,
          parseData: anyNamed('parseData'),
          fetchPolicy: FetchPolicy.networkOnly,
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );
  });

  group('purchaseProduct', () {
    test(
      'Should return [CustomerModel] when adapter successfully fetch customer data',
      () async {
        final tId = faker.guid.guid();
        final tCustomerId = faker.guid.guid();
        final tCustomerName = faker.person.name();
        final tCustomerBalance = faker.randomGenerator.decimal(min: 1000);
        final tQueryResult =
            QueryResult(source: QueryResultSource.network, data: {
          'purchase': {
            'success': true,
            'customer': {
              'id': tCustomerId,
              'name': tCustomerName,
              'balance': tCustomerBalance,
            }
          }
        });
        final tCustomer = CustomerModel(
          id: tCustomerId,
          name: tCustomerName,
          balance: tCustomerBalance,
        );
        when(mockGraphqlAdapterTest.runMutation(
          mutation: anyNamed('mutation'),
          payload: anyNamed('payload'),
          fetchPolicy: anyNamed('fetchPolicy'),
        )).thenAnswer((_) async => Right(tQueryResult));

        final customer = await remoteDatasource.purchaseProduct(id: tId);

        expect(customer, tCustomer);
        verify(mockGraphqlAdapterTest.runMutation(
          mutation: purchaseProductMutation,
          payload: {'productId': tId},
          fetchPolicy: FetchPolicy.noCache,
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );

    test(
      'Should throw [ServerException] when purchase returns any error',
      () async {
        final tId = faker.guid.guid();
        final tQueryResult =
            QueryResult(source: QueryResultSource.network, data: {
          'purchase': {
            'success': false,
            'errorMessage': faker.lorem.sentence(),
          }
        });
        when(mockGraphqlAdapterTest.runMutation(
          mutation: anyNamed('mutation'),
          payload: anyNamed('payload'),
          fetchPolicy: anyNamed('fetchPolicy'),
        )).thenAnswer((_) async => Right(tQueryResult));

        final call = remoteDatasource.purchaseProduct;

        expect(
          () => call(id: tId),
          throwsA(isInstanceOf<exceptions.ServerException>()),
        );
        verify(mockGraphqlAdapterTest.runMutation(
          mutation: purchaseProductMutation,
          payload: {'productId': tId},
          fetchPolicy: FetchPolicy.noCache,
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );

    test(
      'Should throw [ServerException] when adapter returns any [Exception]',
      () async {
        final tId = faker.guid.guid();
        final tGraphqlError = GraphQLError(message: faker.lorem.sentence());
        final tOperationException = OperationException(
          graphqlErrors: [tGraphqlError],
        );

        when(mockGraphqlAdapterTest.runMutation(
          mutation: anyNamed('mutation'),
          payload: anyNamed('payload'),
          fetchPolicy: anyNamed('fetchPolicy'),
        )).thenAnswer((_) async => Left(tOperationException));

        final call = remoteDatasource.purchaseProduct;

        expect(
          () => call(id: tId),
          throwsA(isInstanceOf<exceptions.ServerException>()),
        );
        verify(mockGraphqlAdapterTest.runMutation(
          mutation: purchaseProductMutation,
          payload: {'productId': tId},
          fetchPolicy: FetchPolicy.noCache,
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );
  });
}
