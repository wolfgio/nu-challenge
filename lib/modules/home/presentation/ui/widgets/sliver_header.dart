import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/platform/currency_formats.dart';
import '../../../../customer/domain/entities/customer.dart';

import '../../../../../core/ui/styles/colors.dart';

class HomeSliverHeader implements SliverPersistentHeaderDelegate {
  final Customer? customer;
  final bool isLoading;

  HomeSliverHeader({
    this.customer,
    this.isLoading = false,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: ColorsPallete.primary,
      child: Stack(
        children: [
          if (isLoading)
            Align(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(color: ColorsPallete.accent),
              ),
            ),
          if (!isLoading)
            Positioned(
              top: 64,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: titleOpacity(shrinkOffset),
                duration: Duration(milliseconds: 300),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'User avatar',
                        child: CircleAvatar(
                          backgroundImage:
                              Image.asset('assets/images/jerry_avatar.png')
                                  .image,
                          radius: 48,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          customer?.name ?? '',
                          semanticsLabel: 'username',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Text(
                        GetIt.I<CurrencyFormats>()
                            .formatCurrency(customer?.balance ?? 0),
                        semanticsLabel: 'current balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double titleOpacity(double shrinkOffset) {
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
  }

  @override
  double get maxExtent => 260;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}
