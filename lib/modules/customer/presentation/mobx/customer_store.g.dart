// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerStore on CustomerStoreBase, Store {
  final _$customerAtom = Atom(name: 'CustomerStoreBase.customer');

  @override
  Customer? get customer {
    _$customerAtom.reportRead();
    return super.customer;
  }

  @override
  set customer(Customer? value) {
    _$customerAtom.reportWrite(value, super.customer, () {
      super.customer = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'CustomerStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$getCustomerAsyncAction = AsyncAction('CustomerStoreBase.getCustomer');

  @override
  Future<void> getCustomer() {
    return _$getCustomerAsyncAction.run(() => super.getCustomer());
  }

  final _$purchaseProductAsyncAction =
      AsyncAction('CustomerStoreBase.purchaseProduct');

  @override
  Future<bool> purchaseProduct({required String id}) {
    return _$purchaseProductAsyncAction
        .run(() => super.purchaseProduct(id: id));
  }

  @override
  String toString() {
    return '''
customer: ${customer},
isLoading: ${isLoading}
    ''';
  }
}
