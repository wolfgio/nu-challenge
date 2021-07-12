import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/adapters/graphql_adapter.dart';
import 'package:nu_challenge/modules/customer/data/graphql/queries.dart';
import 'package:nu_challenge/modules/customer/data/models/customer_model.dart';

import 'graphql_adapter_test.mocks.dart';

@GenerateMocks([GraphQLClient])
void main() {
  late MockGraphQLClient mockGraphQLClient;
  late GraphQlAdapterImpl graphQlAdapterImpl;

  setUp(() {
    mockGraphQLClient = MockGraphQLClient();
    graphQlAdapterImpl = GraphQlAdapterImpl(client: mockGraphQLClient);
  });

  group('runQuery', () {
    test(
      'Should return [CustomerModel] when query completes',
      () async {
        final tCustomerData = {
          'id': faker.guid.guid(),
          'name': faker.person.name(),
          'balance': faker.randomGenerator.integer(1000),
        };
        final tCustomerModel = CustomerModel.fromGraphQl(tCustomerData);
        final tQueryResult = QueryResult(
          source: QueryResultSource.network,
          data: tCustomerData,
        );
        when(mockGraphQLClient.query(any))
            .thenAnswer((_) async => tQueryResult);

        final customer = await graphQlAdapterImpl.runQuery(
          query: getCustomerQuery,
          parseData: (data) => CustomerModel.fromGraphQl(data),
        );

        expect(customer, Right(tCustomerModel));
        verify(mockGraphQLClient.query(any));
        verifyNoMoreInteractions(mockGraphQLClient);
      },
    );

    test('Should return [OperationException] when query fails', () async {
      final tOperationException = OperationException();
      final tQueryResult = QueryResult(
        source: QueryResultSource.network,
        exception: tOperationException,
      );
      when(mockGraphQLClient.query(any)).thenAnswer((_) async => tQueryResult);

      final exception = await graphQlAdapterImpl.runQuery(
        query: getCustomerQuery,
      );

      expect(exception, Left(tOperationException));
      verify(mockGraphQLClient.query(any));
      verifyNoMoreInteractions(mockGraphQLClient);
    });
  });
}
