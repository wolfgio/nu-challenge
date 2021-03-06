import 'package:get_it/get_it.dart';

import '../../../core/config/feature_setup.dart';
import '../data/datasources/customer_remote_datasource.dart';
import '../data/repositories/customer_repository_impl.dart';
import '../domain/repositories/customer_repository.dart';
import '../domain/usecases/get_customer_usecase.dart';
import '../domain/usecases/purchase_product_usecase.dart';
import '../presentation/mobx/customer_store.dart';

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
    GetIt.I.registerLazySingleton<PurchaseProductUseCase>(
      () => PurchaseProductUseCase(repository: GetIt.I()),
    );
  }

  @override
  void initStates() {
    GetIt.I.registerLazySingleton<CustomerStore>(
      () => CustomerStore(
        getCustomerUseCase: GetIt.I(),
        purchaseProductUseCase: GetIt.I(),
      ),
    );
  }

  @override
  void init() {
    initDatasources();
    initRepositories();
    initUsecases();
    initStates();
  }
}
