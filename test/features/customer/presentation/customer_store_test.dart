import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/features/customer/domain/entities/customer.dart';
import 'package:nu_challenge/features/customer/domain/usecases/get_customer_usecase.dart';
import 'package:nu_challenge/features/customer/presentation/mobx/customer_store.dart';

import 'customer_store_test.mocks.dart';

@GenerateMocks([GetCustomerUseCase])
void main() {
  late MockGetCustomerUseCase getCustomerUseCase;
  late CustomerStore store;

  setUp(() {
    getCustomerUseCase = MockGetCustomerUseCase();
    store = CustomerStore(getCustomerUseCase: getCustomerUseCase);
  });

  group('getCustomer', () {
    test(
      'Should set at [Customer] store obsevable when usecase successfully returns Entity',
      () async {
        final tCustomer = Customer(
          id: faker.guid.guid(),
          name: faker.person.name(),
          balance: faker.randomGenerator.integer(1000).toString(),
        );

        when(getCustomerUseCase(any)).thenAnswer((_) async => Right(tCustomer));

        expect(store.customer, null);

        await store.getCustomer();

        expect(store.customer, tCustomer);
        verify(getCustomerUseCase(NoParams()));
        verifyNoMoreInteractions(getCustomerUseCase);
      },
    );

    test(
      'Should throw [Failure] when usecase return any [Failure]',
      () async {
        final tFailure = ServerFailure(message: faker.lorem.sentence());
        when(getCustomerUseCase(any)).thenAnswer((_) async => Left(tFailure));

        expect(store.customer, null);

        final call = store.getCustomer;

        expect(() => call(), throwsA(isInstanceOf<ServerFailure>()));
        verify(getCustomerUseCase(NoParams()));
        verifyNoMoreInteractions(getCustomerUseCase);
      },
    );
  });
}
