import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/platform/currency_formats.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/presentation/ui/widgets/product_card.dart';

import 'product_card_test.mocks.dart';

@GenerateMocks([CurrencyFormats])
void main() {
  late MockCurrencyFormats currencyFormats;

  setUp(() {
    currencyFormats = MockCurrencyFormats();
  });

  Widget createProductCard(
    Product product,
    MockCurrencyFormats currencyFormats, {
    Function(String id)? onPress,
    bool isLoading = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ProductCard(
            product: product,
            currencyFormats: currencyFormats,
            onPress: onPress,
            isLoading: isLoading,
          ),
        ),
      ),
    );
  }

  testWidgets('Should display [Product] info', (tester) async {
    final tProduct = Product(
      id: faker.guid.guid(),
      price: faker.randomGenerator.decimal(min: 1000),
      name: faker.lorem.word(),
      description: faker.lorem.sentence(),
      imageUrl: faker.image.image(),
    );

    when(currencyFormats.formatCurrency(tProduct.price))
        .thenReturn(tProduct.price.toString());
    await tester.pumpWidget(createProductCard(tProduct, currencyFormats));

    expect(find.text(tProduct.name), findsOneWidget);
    expect(find.text(tProduct.description), findsOneWidget);
    expect(find.text(tProduct.price.toString()), findsOneWidget);
  });

  testWidgets(
    'Should display loading indicator when isLoading is true',
    (tester) async {
      final tProduct = Product(
        id: faker.guid.guid(),
        price: faker.randomGenerator.decimal(min: 1000),
        name: faker.lorem.word(),
        description: faker.lorem.sentence(),
        imageUrl: faker.image.image(),
      );

      when(currencyFormats.formatCurrency(tProduct.price))
          .thenReturn(tProduct.price.toString());
      await tester.pumpWidget(createProductCard(
        tProduct,
        currencyFormats,
        isLoading: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets(
    'Should call function when button is pressed and pass [Product] id as parameter',
    (tester) async {
      final tProduct = Product(
        id: faker.guid.guid(),
        price: faker.randomGenerator.decimal(min: 1000),
        name: faker.lorem.word(),
        description: faker.lorem.sentence(),
        imageUrl: faker.image.image(),
      );

      void tFunction(String id) {
        expect(id, tProduct.id);
      }

      when(currencyFormats.formatCurrency(tProduct.price))
          .thenReturn(tProduct.price.toString());
      await tester.pumpWidget(createProductCard(
        tProduct,
        currencyFormats,
        onPress: tFunction,
        isLoading: false,
      ));

      await tester.tap(find.byType(ElevatedButton));
    },
  );
}
