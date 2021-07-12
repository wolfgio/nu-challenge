import 'package:mobx/mobx.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/customer.dart';
import '../../domain/usecases/get_customer_usecase.dart';
import '../../domain/usecases/purchase_product_usecase.dart';

part 'customer_store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  final GetCustomerUseCase getCustomerUseCase;
  final PurchaseProductUseCase purchaseProductUseCase;

  CustomerStoreBase({
    required this.getCustomerUseCase,
    required this.purchaseProductUseCase,
  });

  @observable
  Customer? customer;

  @observable
  bool isLoading = false;

  @action
  Future<void> getCustomer() async {
    isLoading = true;

    final failureOrCustomer = await getCustomerUseCase(NoParams());

    isLoading = false;

    return failureOrCustomer.fold(
      (failure) => Future.error(failure),
      (customer) => this.customer = customer,
    );
  }

  @action
  Future<bool> purchaseProduct({required String id}) async {
    isLoading = true;

    final failureOrCustomer =
        await purchaseProductUseCase(PurchaseProductParams(id));

    isLoading = false;

    return failureOrCustomer.fold(
      (failure) => Future.error(failure),
      (customer) {
        this.customer = customer;
        return true;
      },
    );
  }
}
