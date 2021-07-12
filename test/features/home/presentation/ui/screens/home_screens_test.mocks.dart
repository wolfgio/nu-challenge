// Mocks generated by Mockito 5.0.10 from annotations
// in nu_challenge/test/features/home/presentation/ui/screens/home_screens_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nu_challenge/core/errors/failures.dart' as _i7;
import 'package:nu_challenge/core/platform/currency_formats.dart' as _i13;
import 'package:nu_challenge/core/usecases/usecase.dart' as _i9;
import 'package:nu_challenge/modules/customer/domain/entities/customer.dart'
    as _i8;
import 'package:nu_challenge/modules/customer/domain/repositories/customer_repository.dart'
    as _i2;
import 'package:nu_challenge/modules/customer/domain/usecases/get_customer_usecase.dart'
    as _i5;
import 'package:nu_challenge/modules/customer/domain/usecases/purchase_product_usecase.dart'
    as _i12;
import 'package:nu_challenge/modules/products/domain/entities/product.dart'
    as _i11;
import 'package:nu_challenge/modules/products/domain/repositories/product_repository.dart'
    as _i4;
import 'package:nu_challenge/modules/products/domain/usecases/get_products_usescase.dart'
    as _i10;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeCustomerRepository extends _i1.Fake
    implements _i2.CustomerRepository {}

class _FakeEither<L, R> extends _i1.Fake implements _i3.Either<L, R> {
  @override
  String toString() => super.toString();
}

class _FakeProductRepository extends _i1.Fake implements _i4.ProductRepository {
}

/// A class which mocks [GetCustomerUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCustomerUseCase extends _i1.Mock
    implements _i5.GetCustomerUseCase {
  MockGetCustomerUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CustomerRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeCustomerRepository()) as _i2.CustomerRepository);
  @override
  _i6.Future<_i3.Either<_i7.Failure, _i8.Customer>> call(
          _i9.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i7.Failure, _i8.Customer>>.value(
                  _FakeEither<_i7.Failure, _i8.Customer>()))
          as _i6.Future<_i3.Either<_i7.Failure, _i8.Customer>>);
}

/// A class which mocks [GetProductsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetProductsUseCase extends _i1.Mock
    implements _i10.GetProductsUseCase {
  MockGetProductsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.ProductRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeProductRepository()) as _i4.ProductRepository);
  @override
  _i6.Future<_i3.Either<_i7.Failure, List<_i11.Product>>> call(
          _i9.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i7.Failure, List<_i11.Product>>>.value(
                      _FakeEither<_i7.Failure, List<_i11.Product>>()))
          as _i6.Future<_i3.Either<_i7.Failure, List<_i11.Product>>>);
}

/// A class which mocks [PurchaseProductUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockPurchaseProductUseCase extends _i1.Mock
    implements _i12.PurchaseProductUseCase {
  MockPurchaseProductUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CustomerRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeCustomerRepository()) as _i2.CustomerRepository);
  @override
  _i6.Future<_i3.Either<_i7.Failure, _i8.Customer>> call(
          _i12.PurchaseProductParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i7.Failure, _i8.Customer>>.value(
                  _FakeEither<_i7.Failure, _i8.Customer>()))
          as _i6.Future<_i3.Either<_i7.Failure, _i8.Customer>>);
}

/// A class which mocks [CurrencyFormats].
///
/// See the documentation for Mockito's code generation for more information.
class MockCurrencyFormats extends _i1.Mock implements _i13.CurrencyFormats {
  MockCurrencyFormats() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String formatCurrency(double? amount) =>
      (super.noSuchMethod(Invocation.method(#formatCurrency, [amount]),
          returnValue: '') as String);
}