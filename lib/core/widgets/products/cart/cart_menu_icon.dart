import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../views/cart/logic/cubit/cart_cubit/cart_cubit.dart';
import '../../../constants/colors.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
  });

  final VoidCallback onPressed;
  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit,CartState>(
      builder: (context,state) {
        log('CartCubit State: $state');
        int count = 0;
        if (state is CartLoaded) count = state.totalItems;
        return Stack(
          children: [
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Iconsax.shopping_bag,
                color: iconColor,
              ),
            ),
            if (count > 0)
            Positioned(
              right: 0,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: counterBgColor ?? (TColors.grey),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "$count",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: TColors.primary,
                          fontSizeFactor: 0.9,
                        ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
