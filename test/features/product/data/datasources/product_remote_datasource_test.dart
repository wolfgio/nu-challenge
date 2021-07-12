import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/exceptions.dart' as exceptions;
import 'package:nu_challenge/modules/products/data/datasources/product_remote_datasource.dart';
import 'package:nu_challenge/modules/products/data/graphql/queries.dart';
import 'package:nu_challenge/modules/products/data/models/product_model.dart';

import '../../../../mocks/adapter_mocks.dart';
import 'product_remote_datasource_test.mocks.dart';

@GenerateMocks([GraphqlAdapterTest])
void main() {
  late MockGraphqlAdapterTest mockGraphqlAdapterTest;
  late ProductRemoteDatasourceImpl remoteDatasource;

  setUp(() {
    mockGraphqlAdapterTest = MockGraphqlAdapterTest();
    remoteDatasource = ProductRemoteDatasourceImpl(
      graphQlAdapter: mockGraphqlAdapterTest,
    );
  });

  group('getProducts', () {
    test(
      'Should return [ProductModel] when adapter successfully fetch products data',
      () async {
        final tData = {
          'viewer': {
            'offers': [
              {
                'id': faker.guid.guid(),
                'price': faker.randomGenerator.decimal(min: 1000),
                'product': {
                  'name': faker.lorem.word(),
                  'description': faker.lorem.sentence(),
                  'image': faker.image.image(),
                },
              }
            ]
          }
        };
        final queryResult =
            QueryResult(source: QueryResultSource.network, data: tData);
        when(mockGraphqlAdapterTest.runQuery(
          query: anyNamed('query'),
          fetchPolicy: anyNamed('fetchPolicy'),
        )).thenAnswer((_) async => Right(queryResult));

        final products = await remoteDatasource.getProducts();

        expect(
          products?.first,
          ProductModel.fromGraphQl(
              (tData['viewer']?['offers'] as List<Map<String, dynamic>>).first),
        );
        verify(mockGraphqlAdapterTest.runQuery(
          query: getProductsQuery,
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
                query: anyNamed('query'), fetchPolicy: anyNamed('fetchPolicy')))
            .thenAnswer((_) async => Left(tOperationException));

        final call = remoteDatasource.getProducts;

        expect(
          () => call(),
          throwsA(isInstanceOf<exceptions.ServerException>()),
        );
        verify(mockGraphqlAdapterTest.runQuery(
          query: getProductsQuery,
          fetchPolicy: FetchPolicy.networkOnly,
        ));
        verifyNoMoreInteractions(mockGraphqlAdapterTest);
      },
    );
  });
}
