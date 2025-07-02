import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/cart/ui/widgets/cart_items.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/widgets/appbar/appbar.dart';
import '../../checkout/checkout.dart';
import '../logic/cubit/cart_cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartInitial) {
          context.read<CartCubit>().loadCart();
        }
        return Scaffold(
          appBar: TAppBar(
            showBackArrow: true,
            title: Text(
              LocaleKeys.cart_title.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),

            /// Items in Cart
            child: TCartItems(),
          ),

          /// Checkout Button
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state is CartLoaded && state.items.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.total.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'SAR ${state.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (state is CartLoaded && state.items.isNotEmpty)
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            }
                            : null,
                    child: Text(LocaleKeys.checkout.tr()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
