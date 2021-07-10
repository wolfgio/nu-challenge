import 'package:get_it/get_it.dart';
import '../../../core/config/feature_setup.dart';
import '../data/repositories/customer_repository_impl.dart';
import '../domain/repositories/customer_repository.dart';
import '../domain/usecases/get_customer_usecase.dart';

import '../data/datasources/customer_remote_datasource.dart';

class CustomerSetup implements FeatureSetup {
  @override
  void initDatasources() {
    GetIt.I.registerLazySingleton<CustomerRemoteDatasource>(
      () => CustomerRemoteDatasourceImpl(graphQlAdapter: GetIt.I()),
    );
  }

  @override
  void initRepositories() {
    GetIt.I.registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(
        dataSource: GetIt.I(),
        networkUtils: GetIt.I(),
      ),
    );
  }

  @override
  void initUsecases() {
    GetIt.I.registerLazySingleton<GetCustomerUseCase>(
      () => GetCustomerUseCase(repository: GetIt.I()),
    );
  }

  @override
  void init() {
    initDatasources();
    initRepositories();
    initUsecases();
  }
}
