import 'package:mobx/mobx.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/customer.dart';
import '../../domain/usecases/get_customer_usecase.dart';

part 'customer_store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  final GetCustomerUseCase getCustomerUseCase;

  CustomerStoreBase({required this.getCustomerUseCase});

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
}
