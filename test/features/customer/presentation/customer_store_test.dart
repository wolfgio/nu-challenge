import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/modules/customer/domain/entities/customer.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/get_customer_usecase.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/purchase_product_usecase.dart';
import 'package:nu_challenge/modules/customer/presentation/mobx/customer_store.dart';

import 'customer_store_test.mocks.dart';

@GenerateMocks([GetCustomerUseCase, PurchaseProductUseCase])
void main() {
  late MockGetCustomerUseCase getCustomerUseCase;
  late MockPurchaseProductUseCase purchaseProductUseCase;
  late CustomerStore store;

  setUp(() {
    getCustomerUseCase = MockGetCustomerUseCase();
    purchaseProductUseCase = MockPurchaseProductUseCase();
    store = CustomerStore(
        getCustomerUseCase: getCustomerUseCase,
        purchaseProductUseCase: purchaseProductUseCase);
  });

  group('getCustomer', () {
    test(
      'Should set at [Customer] store obsevable when usecase successfully returns Entity',
      () async {
        final tCustomer = Customer(
          id: faker.guid.guid(),
          name: faker.person.name(),
          balance: faker.randomGenerator.decimal(min: 1000),
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

  group('purchaseProduct', () {
    test(
      'Should set at [Customer] store obsevable when usecase successfully returns Entity',
      () async {
        final tId = faker.guid.guid();
        final tCustomer = Customer(
          id: faker.guid.guid(),
          name: faker.person.name(),
          balance: faker.randomGenerator.decimal(min: 1000),
        );

        when(purchaseProductUseCase(any))
            .thenAnswer((_) async => Right(tCustomer));

        expect(store.customer, null);

        await store.purchaseProduct(id: tId);

        expect(store.customer, tCustomer);
        verify(purchaseProductUseCase(PurchaseProductParams(tId)));
        verifyNoMoreInteractions(purchaseProductUseCase);
      },
    );

    test(
      'Should throw [Failure] when usecase return any [Failure]',
      () async {
        final tId = faker.guid.guid();
        final tFailure = ServerFailure(message: faker.lorem.sentence());
        when(purchaseProductUseCase(any))
            .thenAnswer((_) async => Left(tFailure));

        expect(store.customer, null);

        final call = store.purchaseProduct;

        expect(() => call(id: tId), throwsA(isInstanceOf<ServerFailure>()));
        verify(purchaseProductUseCase(PurchaseProductParams(tId)));
        verifyNoMoreInteractions(purchaseProductUseCase);
      },
    );
  });
}
