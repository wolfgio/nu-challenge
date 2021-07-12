import 'package:graphql/client.dart';
import '../graphql/mutations.dart';

import '../../../../core/adapters/graphql_adapter.dart';
import '../../../../core/errors/exceptions.dart' as exceptions;
import '../graphql/queries.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDatasource {
  /// get customer's basic info such as name, id and balance
  /// and returns an [CustomerModel] may throw [ServerException]
  Future<CustomerModel?> getCustomer();

  /// makes an Purchase and returns [CustomerModel] with updated balance
  /// may throw [ServerException]
  Future<CustomerModel?> purchaseProduct({required String id});
}

class CustomerRemoteDatasourceImpl implements CustomerRemoteDatasource {
  final GraphQlAdapter graphQlAdapter;

  CustomerRemoteDatasourceImpl({required this.graphQlAdapter});

  @override
  Future<CustomerModel?> getCustomer() async {
    final exceptionOrCustomer = await graphQlAdapter.runQuery(
      query: getCustomerQuery,
      fetchPolicy: FetchPolicy.networkOnly,
      parseData: (data) => CustomerModel.fromGraphQl(data?['viewer']),
    );

    return exceptionOrCustomer.fold(
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
      (customer) => customer,
    );
  }

  @override
  Future<CustomerModel?> purchaseProduct({required String id}) async {
    final exceptionOrCustomer = await graphQlAdapter.runMutation(
      mutation: purchaseProductMutation,
      payload: {'productId': id},
      fetchPolicy: FetchPolicy.noCache,
    );

    return exceptionOrCustomer.fold(
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
      (result) {
        if (result is QueryResult) {
          final res = result.data?['purchase'];

          if (res['success'] == false) {
            throw exceptions.ServerException(
              message: res['errorMessage'],
            );
          }

          return CustomerModel.fromGraphQl(res['customer']);
        }
      },
    );
  }
}
