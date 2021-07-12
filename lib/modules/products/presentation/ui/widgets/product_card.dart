import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/platform/currency_formats.dart';
import '../../../../../core/ui/styles/colors.dart';
import '../../../domain/entities/product.dart';
import 'product_card_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(String id)? onPress;
  final bool isLoading;

  const ProductCard({
    Key? key,
    required this.product,
    this.onPress,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: textTheme.headline5),
              SizedBox(height: 20),
              AspectRatio(
                child: ProductCardImage(url: product.imageUrl),
                aspectRatio: 16 / 9,
              ),
              SizedBox(height: 12),
              Text(
                product.description,
                style: textTheme.subtitle2,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    GetIt.I<CurrencyFormats>().formatCurrency(product.price),
                  ),
                  ElevatedButton.icon(
                    onPressed: onPress != null && !isLoading
                        ? () => onPress!(product.id)
                        : null,
                    icon: !isLoading
                        ? Icon(Icons.shopping_cart_outlined)
                        : Container(),
                    label: isLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: ColorsPallete.accent,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Text('Buy'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
