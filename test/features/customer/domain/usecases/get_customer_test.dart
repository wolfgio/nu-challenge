import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/modules/customer/domain/entities/customer.dart';
import 'package:nu_challenge/modules/customer/domain/repositories/customer_repository.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/get_customer_usecase.dart';

import '../../../../mocks/repositories_mocks.dart';
import 'get_customer_test.mocks.dart';

@GenerateMocks([CustomerRepositoryTest])
void main() {
  late CustomerRepository customerRepositoyMock;
  late GetCustomerUseCase useCase;

  setUp(() {
    customerRepositoyMock = MockCustomerRepositoryTest();
    useCase = GetCustomerUseCase(repository: customerRepositoyMock);
  });

  test(
    'Should return [Failure] when repository fails',
    () async {
      final tFailure =
          ServerFailure(message: faker.lorem.sentence(), code: '500');
      when(customerRepositoyMock.getCustomer())
          .thenAnswer((_) async => Left(tFailure));

      final customer = await useCase(NoParams());

      expect(customer, Left(tFailure));
      verify(customerRepositoyMock.getCustomer());
      verifyNoMoreInteractions(customerRepositoyMock);
    },
  );

  test('Should return [Customer] when repository succeed', () async {
    final tCustomer = Customer(
      id: faker.guid.guid(),
      name: faker.person.name(),
      balance: faker.randomGenerator.integer(1000).toString(),
    );
    when(customerRepositoyMock.getCustomer())
        .thenAnswer((_) async => Right(tCustomer));

    final customer = await useCase(NoParams());

    expect(customer, Right(tCustomer));
    verify(customerRepositoyMock.getCustomer());
    verifyNoMoreInteractions(customerRepositoyMock);
  });
}
