import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nu_challenge/core/platform/currency_formats.dart';
import 'package:nu_challenge/modules/products/domain/entities/product.dart';
import 'package:nu_challenge/modules/products/presentation/ui/widgets/product_card_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
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
                    onPressed: () {},
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: Text('Buy'),
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
