// Mocks generated by Mockito 5.0.10 from annotations
// in nu_challenge/test/features/customer/usecases/get_customer_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nu_challenge/core/errors/failures.dart' as _i5;
import 'package:nu_challenge/features/customer/domain/entities/customer.dart'
    as _i6;

import '../../../mocks/repositories_mocks.dart' as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither<L, R> extends _i1.Fake implements _i2.Either<L, R> {
  @override
  String toString() => super.toString();
}

/// A class which mocks [CustomerRepositoryTest].
///
/// See the documentation for Mockito's code generation for more information.
class MockCustomerRepositoryTest extends _i1.Mock
    implements _i3.CustomerRepositoryTest {
  MockCustomerRepositoryTest() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Customer>> getCustomer() =>
      (super.noSuchMethod(Invocation.method(#getCustomer, []),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.Customer>>.value(
                  _FakeEither<_i5.Failure, _i6.Customer>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.Customer>>);
  @override
  String toString() => super.toString();
}
