import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/platform/currency_formats.dart';
import '../../../../../core/platform/scaffold_handler.dart';
import '../../../../../core/ui/styles/colors.dart';
import '../../../../customer/presentation/mobx/customer_store.dart';
import '../../../../products/presentation/mobx/product_store.dart';
import '../../../../products/presentation/ui/widgets/product_card.dart';
import '../widgets/sliver_header.dart';

class HomeScreen extends StatefulWidget {
  final CustomerStore customerStore;
  final ProductStore productStore;
  final ScaffoldHandler scaffoldHandler;
  final CurrencyFormats currencyFormats;

  const HomeScreen({
    Key? key,
    required this.customerStore,
    required this.productStore,
    required this.scaffoldHandler,
    required this.currencyFormats,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _fetchUser();
    _fetchProducts();
    super.initState();
  }

  void _fetchUser() {
    widget.customerStore.getCustomer().catchError((error) {
      if (error is ServerFailure) {
        return widget.scaffoldHandler.showErrorScaffold(message: error.message);
      }
      widget.scaffoldHandler.showErrorScaffold(message: error.toString());
    });
  }

  void _fetchProducts() {
    widget.productStore.getProducts().catchError((error) {
      if (error is ServerFailure) {
        return widget.scaffoldHandler.showErrorScaffold(message: error.message);
      }
      widget.scaffoldHandler.showErrorScaffold(message: error.toString());
    });
  }

  void _purchaseProduct(String id) {
    widget.customerStore.purchaseProduct(id: id).catchError((error) {
      if (error is ServerFailure) {
        widget.scaffoldHandler.showErrorScaffold(message: error.message);
      } else {
        widget.scaffoldHandler.showErrorScaffold(message: error.toString());
      }

      return false;
    }).then((success) {
      if (success) {
        widget.scaffoldHandler
            .showSuccessScaffold(message: 'Purchase successfully made!');
      }
      return success;
    });
  }

  Future<void> _onRefreshHandler() async {
    _fetchUser();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _onRefreshHandler,
        child: CustomScrollView(
          slivers: [
            Observer(
              builder: (_) => SliverPersistentHeader(
                delegate: HomeSliverHeader(
                  customer: widget.customerStore.customer,
                  isLoading: widget.customerStore.isLoading,
                ),
              ),
            ),
            Observer(builder: (_) {
              final productLoading = widget.productStore.isLoading;
              final customerLoading = widget.customerStore.isLoading;

              if (productLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorsPallete.accent,
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                    final productStore = widget.productStore;

                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ProductCard(
                          product: productStore.products![index],
                          isLoading: customerLoading,
                          onPress: _purchaseProduct,
                          currencyFormats: widget.currencyFormats,
                        ),
                      );
                    }

                    return ProductCard(
                      product: productStore.products![index],
                      onPress: _purchaseProduct,
                      isLoading: customerLoading,
                      currencyFormats: widget.currencyFormats,
                    );
                  },
                  childCount: widget.productStore.products?.length ?? 0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
