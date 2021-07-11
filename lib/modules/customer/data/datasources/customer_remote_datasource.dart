import 'package:graphql/client.dart';

import '../../../../core/adapters/graphql_adapter.dart';
import '../../../../core/errors/exceptions.dart' as exceptions;
import '../graphql/queries.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDatasource {
  /// get customer's basic info such as name, id and balance
  /// and returns an [CustomerModel] may throw [exceptions.ServerException]
  Future<CustomerModel?> getCustomer();
}

class CustomerRemoteDatasourceImpl implements CustomerRemoteDatasource {
  final GraphQlAdapter graphQlAdapter;

  CustomerRemoteDatasourceImpl({required this.graphQlAdapter});

  @override
  Future<CustomerModel?> getCustomer() async {
    final exceptionORCustomer = await graphQlAdapter.runQuery(
      query: getCustomerQuery,
      fetchPolicy: FetchPolicy.networkOnly,
      parseData: (data) => CustomerModel.fromGraphQl(data),
    );

    return exceptionORCustomer.fold(
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
}
