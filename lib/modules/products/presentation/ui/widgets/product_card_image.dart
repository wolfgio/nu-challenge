import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui/styles/colors.dart';

class ProductCardImage extends StatelessWidget {
  final String? url;

  const ProductCardImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url!,
      placeholder: (_, __) => Container(
        child: Center(
          child: CircularProgressIndicator(
            color: ColorsPallete.accent,
          ),
        ),
      ),
      imageBuilder: (_, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        child: Center(
          child: Icon(
            Icons.no_photography_outlined,
            size: 48,
            color: Colors.white24,
          ),
        ),
      ),
    );
  }
}
