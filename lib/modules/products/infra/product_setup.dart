import 'package:get_it/get_it.dart';

import '../../../core/config/feature_setup.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_products_usescase.dart';
import '../presentation/mobx/product_store.dart';

class ProductSetup implements FeatureSetup {
  @override
  void initDatasources() {
    GetIt.I.registerLazySingleton<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImpl(graphQlAdapter: GetIt.I()),
    );
  }

  @override
  void initRepositories() {
    GetIt.I.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        dataSource: GetIt.I(),
        networkUtils: GetIt.I(),
      ),
    );
  }

  @override
  void initUsecases() {
    GetIt.I.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(repository: GetIt.I()),
    );
  }

  @override
  void initStates() {
    GetIt.I.registerLazySingleton<ProductStore>(
      () => ProductStore(getProductsUseCase: GetIt.I()),
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
