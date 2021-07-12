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
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ProductCard(
              product: tProduct,
              currencyFormats: currencyFormats,
              isLoading: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text(tProduct.name), findsOneWidget);
    expect(find.text(tProduct.description), findsOneWidget);
    expect(find.text(tProduct.price.toString()), findsOneWidget);
  });
}
