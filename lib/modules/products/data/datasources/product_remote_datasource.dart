import 'package:graphql/client.dart';

import '../../../../core/adapters/graphql_adapter.dart';
import '../../../../core/errors/exceptions.dart' as exceptions;
import '../graphql/queries.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDatasource {
  /// get products's info such as name, pricing, and description
  /// and returns an list of [ProductModel] may throw [exceptions.ServerException]
  Future<List<ProductModel>?> getProducts();
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final GraphQlAdapter graphQlAdapter;

  ProductRemoteDatasourceImpl({required this.graphQlAdapter});

  @override
  Future<List<ProductModel>?> getProducts() async {
    final exceptionORProducts = await graphQlAdapter.runQuery(
      query: getProductsQuery,
      fetchPolicy: FetchPolicy.networkOnly,
    );

    return exceptionORProducts.fold(
      (exception) {
        if (exception is OperationException?) {
          if (exception != null) {
            exception.graphqlErrors.forEach((graphqlError) {
              throw exceptions.ServerException(
                message: graphqlError.message,
                code: graphqlError.extensions?['code'],
              );
            });
          }
        }

        throw exceptions.ServerException(
          code: '500',
          message: exception.toString(),
          stackTrace: StackTrace.fromString(exception.toString()),
        );
      },
      (res) {
        if (res is QueryResult) {
          final offers =
              res.data?['viewer']['offers'] as List<Map<String, dynamic>>;

          return offers
              .map((offer) => ProductModel.fromGraphQl(offer))
              .toList();
        }
      },
    );
  }
}
