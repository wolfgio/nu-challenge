import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/usecases/usecase.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/domain/usecases/get_products_usescase.dart';
import 'package:nu_challenge/modules/products/presentation/mobx/product_store.dart';

import 'product_store_test.mocks.dart';

@GenerateMocks([GetProductsUseCase])
void main() {
  late MockGetProductsUseCase getProductsUseCase;
  late ProductStore store;

  setUp(() {
    getProductsUseCase = MockGetProductsUseCase();
    store = ProductStore(getProductsUseCase: getProductsUseCase);
  });

  group('getProducts', () {
    test(
      'Should set at [Product] store obsevable when usecase successfully returns Entity',
      () async {
        final tProduct = Product(
          id: faker.guid.guid(),
          name: faker.lorem.word(),
          price: faker.randomGenerator.decimal(min: 1000),
          description: faker.lorem.sentence(),
          imageUrl: faker.image.image(),
        );

        when(getProductsUseCase(any))
            .thenAnswer((_) async => Right([tProduct]));

        expect(store.products, null);

        await store.getProducts();

        expect(store.products, [tProduct]);
        verify(getProductsUseCase(NoParams()));
        verifyNoMoreInteractions(getProductsUseCase);
      },
    );

    test(
      'Should throw [Failure] when usecase return any [Failure]',
      () async {
        final tFailure = ServerFailure(message: faker.lorem.sentence());
        when(getProductsUseCase(any)).thenAnswer((_) async => Left(tFailure));

        expect(store.products, null);

        final call = store.getProducts;

        expect(() => call(), throwsA(isInstanceOf<ServerFailure>()));
        verify(getProductsUseCase(NoParams()));
        verifyNoMoreInteractions(getProductsUseCase);
      },
    );
  });
}
