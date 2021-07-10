import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nu_challenge/core/navigation/app_navigator.dart';

import '../adapters/graphql_adapter.dart';
import '../platform/network_utils.dart';

class AppSetup {
  static Future<void> loadEnvs() => dotenv.load(fileName: '.env');

  static GraphQLClient initGraphqlClient() {
    final httpLink = HttpLink(dotenv.env['graphqlAPI']!);
    final authLink = AuthLink(
      getToken: () async => 'Bearer ${dotenv.env['graphqlToken']}',
    );
    final link = authLink.concat(httpLink);

    return GraphQLClient(link: link, cache: GraphQLCache());
  }

  static void initAdapters() {
    GetIt.I.registerLazySingleton<GraphQlAdapter>(
      () => GraphQlAdapterImpl(client: initGraphqlClient()),
    );
  }

  static void initPlatformUtils() {
    GetIt.I.registerLazySingleton<NetworkUtils>(
      () => NetworkUtilsImpl(connectionChecker: InternetConnectionChecker()),
    );
  }

  static void initNavigator() {
    GetIt.I.registerLazySingleton<AppNavigator>(
      () => AppNavigator(),
    );
  }

  static Future<void> init() async {
    await loadEnvs();
    initAdapters();
    initPlatformUtils();
    initNavigator();
  }
}
