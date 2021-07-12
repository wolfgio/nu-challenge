import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/domain/usecases/get_products_usescase.dart';

import '../../../../mocks/repositories_mocks.dart';
import 'get_products_test.mocks.dart';

@GenerateMocks([ProductRepositoryTest])
void main() {
  late MockProductRepositoryTest mockedRepository;
  late GetProductsUseCase useCase;

  setUp(() {
    mockedRepository = MockProductRepositoryTest();
    useCase = GetProductsUseCase(repository: mockedRepository);
  });

  test(
    'Should return [Failure] when repository fails',
    () async {
      final tFailure = ServerFailure(message: faker.lorem.sentence());
      when(mockedRepository.getProducts())
          .thenAnswer((_) async => Left(tFailure));

      final failure = await useCase(NoParams());

      expect(failure, Left(tFailure));
      verify(mockedRepository.getProducts());
      verifyNoMoreInteractions(mockedRepository);
    },
  );

  test('Should return [Product] when repository successfully', () async {
    final tProduct = Product(
      id: faker.guid.guid(),
      name: faker.lorem.word(),
      price: faker.randomGenerator.decimal(min: 1000),
      description: faker.lorem.sentence(),
      imageUrl: faker.image.image(),
    );
    when(mockedRepository.getProducts())
        .thenAnswer((_) async => Right([tProduct]));

    final products = await useCase(NoParams());

    products.fold((l) => null, (r) => expect(r.first, tProduct));

    verify(mockedRepository.getProducts());
    verifyNoMoreInteractions(mockedRepository);
  });
}
