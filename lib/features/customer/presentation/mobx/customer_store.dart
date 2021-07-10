import 'package:mobx/mobx.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/features/customer/domain/entities/customer.dart';
import 'package:nu_challenge/features/customer/domain/usecases/get_customer_usecase.dart';

part 'customer_store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  final GetCustomerUseCase getCustomerUseCase;

  CustomerStoreBase({required this.getCustomerUseCase});

  @observable
  Customer? customer;

  @action
  Future<void> getCustomer() async {
    final failureOrCustomer = await getCustomerUseCase(NoParams());

    failureOrCustomer.fold(
      (failure) => throw failure,
      (customer) => this.customer = customer,
    );
  }
}
