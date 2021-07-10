// Mocks generated by Mockito 5.0.10 from annotations
// in nu_challenge/test/features/customer/data/repositories/customer_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:nu_challenge/features/customer/data/models/customer_model.dart'
    as _i4;

import '../../../../mocks/datasources_mocks.dart' as _i2;
import '../../../../mocks/platform_mocks.dart' as _i5;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [CustomerRemoteDatasourceTest].
///
/// See the documentation for Mockito's code generation for more information.
class MockCustomerRemoteDatasourceTest extends _i1.Mock
    implements _i2.CustomerRemoteDatasourceTest {
  MockCustomerRemoteDatasourceTest() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.CustomerModel?> getCustomer() =>
      (super.noSuchMethod(Invocation.method(#getCustomer, []),
              returnValue: Future<_i4.CustomerModel?>.value())
          as _i3.Future<_i4.CustomerModel?>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [NetworkUtilsTest].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkUtilsTest extends _i1.Mock implements _i5.NetworkUtilsTest {
  MockNetworkUtilsTest() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> get hasInternetAccess =>
      (super.noSuchMethod(Invocation.getter(#hasInternetAccess),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  String toString() => super.toString();
}