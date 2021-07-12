import 'package:mobx/mobx.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usescase.dart';

part 'product_store.g.dart';

class ProductStore = ProductStoreBase with _$ProductStore;

abstract class ProductStoreBase with Store {
  final GetProductsUseCase getProductsUseCase;

  ProductStoreBase({required this.getProductsUseCase});

  @observable
  List<Product>? products;

  @observable
  bool isLoading = false;

  @action
  Future<void> getProducts() async {
    isLoading = true;

    final failureOrCustomer = await getProductsUseCase(NoParams());

    isLoading = false;

    return failureOrCustomer.fold(
      (failure) => Future.error(failure),
      (products) => this.products = products,
    );
  }
}
