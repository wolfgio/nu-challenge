import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nu_challenge/core/errors/failures.dart';
import 'package:nu_challenge/core/platform/currency_formats.dart';
import 'package:nu_challenge/core/platform/scaffold_handler.dart';
import 'package:nu_challenge/modules/customer/domain/entities/customer.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/get_customer_usecase.dart';
import 'package:nu_challenge/modules/customer/domain/usecases/purchase_product_usecase.dart';
import 'package:nu_challenge/modules/customer/presentation/mobx/customer_store.dart';
import 'package:nu_challenge/modules/home/presentation/ui/screens/home_screen.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/domain/usecases/get_products_usescase.dart';
import 'package:nu_challenge/modules/products/presentation/mobx/product_store.dart';
import 'package:nu_challenge/modules/products/presentation/ui/widgets/product_card.dart';

import 'home_screens_test.mocks.dart';

@GenerateMocks([
  GetCustomerUseCase,
  GetProductsUseCase,
  PurchaseProductUseCase,
  CurrencyFormats
])
void main() {
  late MockGetCustomerUseCase getCustomerUseCase;
  late MockGetProductsUseCase getProductsUseCase;
  late MockPurchaseProductUseCase purchaseProductUseCase;
  late CustomerStore customerStore;
  late ProductStore productStore;
  late ScaffoldHandler scaffoldHandler;
  late MockCurrencyFormats currencyFormats;

  setUp(() {
    getCustomerUseCase = MockGetCustomerUseCase();
    getProductsUseCase = MockGetProductsUseCase();
    purchaseProductUseCase = MockPurchaseProductUseCase();
    customerStore = CustomerStore(
      getCustomerUseCase: getCustomerUseCase,
      purchaseProductUseCase: purchaseProductUseCase,
    );
    productStore = ProductStore(getProductsUseCase: getProductsUseCase);
    scaffoldHandler = ScaffoldHandler();
    currencyFormats = MockCurrencyFormats();
  });

  Widget createHomeScreen() {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldHandler.scaffoldKey,
      home: HomeScreen(
        customerStore: customerStore,
        productStore: productStore,
        scaffoldHandler: scaffoldHandler,
        currencyFormats: currencyFormats,
      ),
    );
  }

  testWidgets(
    'Should render [Customer] info and [Product] list',
    (tester) async {
      final tCustomer = Customer(
        id: faker.guid.guid(),
        name: faker.person.name(),
        balance: faker.randomGenerator.decimal(min: 1000),
      );
      final tProduct = Product(
        id: faker.guid.guid(),
        name: faker.lorem.word(),
        description: faker.lorem.word(),
        imageUrl: faker.image.image(),
        price: faker.randomGenerator.decimal(min: 1000),
      );
      when(getCustomerUseCase(any)).thenAnswer((_) async => Right(tCustomer));
      when(getProductsUseCase(any)).thenAnswer((_) async => Right([tProduct]));
      when(currencyFormats.formatCurrency(tCustomer.balance))
          .thenReturn(tCustomer.balance.toString());
      when(currencyFormats.formatCurrency(tProduct.price))
          .thenReturn(tProduct.price.toString());

      await tester.pumpFrames(createHomeScreen(), Duration(seconds: 1));

      expect(find.text(tCustomer.name), findsOneWidget);
      expect(find.text(tCustomer.balance.toString()), findsOneWidget);

      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text(tProduct.name), findsOneWidget);
      expect(find.text(tProduct.description), findsOneWidget);
      expect(find.text(tProduct.price.toString()), findsOneWidget);
    },
  );

  testWidgets(
    'Should render SnackBar with error message',
    (tester) async {
      final tFailure = ServerFailure(message: faker.lorem.sentence());
      final tCustomer = Customer(
        id: faker.guid.guid(),
        name: faker.person.name(),
        balance: faker.randomGenerator.decimal(min: 1000),
      );
      when(getCustomerUseCase(any)).thenAnswer((_) async => Right(tCustomer));
      when(getProductsUseCase(any)).thenAnswer((_) async => Left(tFailure));
      when(currencyFormats.formatCurrency(tCustomer.balance))
          .thenReturn(tCustomer.balance.toString());

      await tester.pumpWidget(createHomeScreen());

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(tFailure.message), findsOneWidget);
    },
  );

  testWidgets(
    'Should render SnackBar when purchase is made',
    (tester) async {
      final tCustomer = Customer(
        id: faker.guid.guid(),
        name: faker.person.name(),
        balance: faker.randomGenerator.decimal(min: 1000),
      );
      final tProduct = Product(
        id: faker.guid.guid(),
        name: faker.lorem.word(),
        description: faker.lorem.word(),
        imageUrl: faker.image.image(),
        price: faker.randomGenerator.decimal(min: 1000),
      );
      when(getCustomerUseCase(any)).thenAnswer((_) async => Right(tCustomer));
      when(getProductsUseCase(any)).thenAnswer((_) async => Right([tProduct]));
      when(purchaseProductUseCase(any))
          .thenAnswer((_) async => Right(tCustomer));
      when(currencyFormats.formatCurrency(tCustomer.balance))
          .thenReturn(tCustomer.balance.toString());
      when(currencyFormats.formatCurrency(tProduct.price))
          .thenReturn(tProduct.price.toString());

      await tester.pumpFrames(createHomeScreen(), Duration(seconds: 1));

      final buyButton = find.byType(ElevatedButton);

      await tester.drag(
          find.byType(CustomScrollView), const Offset(0.0, -1000));
      await tester.pump();

      await tester.tap(buyButton.first);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Purchase successfully made!'), findsOneWidget);
    },
  );
}
