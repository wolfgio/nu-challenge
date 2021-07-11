import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';

abstract class GraphQlAdapter {
  Future<Either<Object?, dynamic>> runQuery({
    required String query,
    parseData(Map<String, dynamic>? data)?,
    Map<String, dynamic>? params,
    FetchPolicy? fetchPolicy,
  });
  Future<Either<Object?, dynamic>> runMutation({
    required String mutation,
    parseData(Map<String, dynamic>? data)?,
    Map<String, dynamic>? payload,
  });
}

class GraphQlAdapterImpl implements GraphQlAdapter {
  final GraphQLClient client;

  GraphQlAdapterImpl({required this.client});

  @override
  Future<Either<Object?, dynamic>> runMutation({
    required String mutation,
    Function(Map<String, dynamic>? data)? parseData,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final options = MutationOptions(
        document: gql(mutation),
        variables: payload ?? {},
      );

      final res = await client.mutate(options);

      if (res.hasException) {
        return Left(res.exception);
      }

      if (parseData != null) {
        return Right(parseData(res.data));
      }

      return Right(res);
    } catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Object?, dynamic>> runQuery({
    required String query,
    Function(Map<String, dynamic>? data)? parseData,
    Map<String, dynamic>? params,
    FetchPolicy? fetchPolicy,
  }) async {
    try {
      final options = QueryOptions(
        document: gql(query),
        fetchPolicy: fetchPolicy,
        variables: params ?? {},
      );

      final res = await client.query(options);

      if (res.hasException) {
        return Left(res.exception);
      }

      if (parseData != null) {
        return Right(parseData(res.data));
      }

      return Right(res);
    } catch (error) {
      return Left(error);
    }
  }
}
