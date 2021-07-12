import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/modules/customer/domain/entities/customer.dart';
import 'package:nu_challenge/modules/customer/domain/repositories/customer_repository.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/purchase_product_usecase.dart';

import '../../../../mocks/repositories_mocks.dart';
import 'purchase_product_test.mocks.dart';

@GenerateMocks([CustomerRepositoryTest])
void main() {
  late CustomerRepository customerRepositoyMock;
  late PurchaseProductUseCase useCase;

  setUp(() {
    customerRepositoyMock = MockCustomerRepositoryTest();
    useCase = PurchaseProductUseCase(repository: customerRepositoyMock);
  });

  test(
    'Should return [Failure] when repository fails',
    () async {
      final tId = faker.guid.guid();
      final tFailure =
          ServerFailure(message: faker.lorem.sentence(), code: '500');
      when(customerRepositoyMock.purchaseProduct(id: tId))
          .thenAnswer((_) async => Left(tFailure));

      final customer = await useCase(PurchaseProductParams(tId));

      expect(customer, Left(tFailure));
      verify(customerRepositoyMock.purchaseProduct(id: tId));
      verifyNoMoreInteractions(customerRepositoyMock);
    },
  );

  test(
    'Should return [Customer] when repository successfully make an purchase',
    () async {
      final tId = faker.guid.guid();
      final tCustomer = Customer(
        id: faker.guid.guid(),
        name: faker.person.name(),
        balance: faker.randomGenerator.decimal(min: 1000),
      );
      when(customerRepositoyMock.purchaseProduct(id: tId))
          .thenAnswer((_) async => Right(tCustomer));

      final customer = await useCase(PurchaseProductParams(tId));

      expect(customer, Right(tCustomer));
      verify(customerRepositoyMock.purchaseProduct(id: tId));
      verifyNoMoreInteractions(customerRepositoyMock);
    },
  );
}
