import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/widgets/products/cart/add_remove_button.dart';
import '../../../../core/widgets/products/cart/cart_item.dart';
import '../../../../core/widgets/texts/t_product_price_text.dart';
import '../../logic/cubit/cart_cubit/cart_cubit.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({super.key, this.showAddRemoveButton = true});

  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading || state is CartInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartLoaded) {
          final cartItems = state.items;

          if (cartItems.isEmpty) {
            return Center(child: Text(LocaleKeys.cart_empty.tr()));
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: cartItems.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: TSizes.spaceBtwSections),
            itemBuilder: (_, index) {
              final item = cartItems[index];
              return Column(
                children: [
                  /// Cart Item
                  TCartItem(
                    product: item,
                    variant:
                    (item.variants != null && item.variants!.isNotEmpty)
                        ? item.variants!.first
                        : null,
                  ),
                  if (showAddRemoveButton)
                    const SizedBox(height: TSizes.spaceBtwItems),

                  /// Add Remove Button Row with total Price
                  if (showAddRemoveButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            /// Extra Space
                            const SizedBox(width: 70),

                            /// Add Remove Buttons
                            TProductQuantityWithAddRemoveButton(
                              quantity: item.quantity,
                              onAdd: () {
                                context.read<CartCubit>().incrementQuantity(
                                  item,
                                );
                              },
                              onRemove: () {
                                context.read<CartCubit>().decrementQuantity(
                                  item,
                                );
                              },
                            ),
                          ],
                        ),

                        /// Product total price
                        TProductPriceText(price: item.price.toString()),
                      ],
                    ),

                  /// Remove from cart button
                  if (showAddRemoveButton)
                    TextButton.icon(
                      onPressed: () async {
                        final bool? shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: TColors.primary,
                            title: Text(
                              LocaleKeys.delete_item_confirm_title.tr(),
                            ),
                            content: Text(
                              LocaleKeys.delete_item_confirm_content.tr(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(false),
                                child: Text(LocaleKeys.cancel.tr()),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(true),
                                child: Text(
                                  LocaleKeys.delete.tr(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true && context.mounted) {
                          context.read<CartCubit>().deleteItemFromCart(item);
                        }
                      },
                      icon: const Icon(
                        Iconsax.trash,
                        size: 16,
                        color: Colors.red,
                      ),
                      label: Text(
                        LocaleKeys.delete_item.tr(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            },
          );
        } else if (state is CartError) {
          return Center(
            child: Text(
              '${LocaleKeys.error_loading_cart.tr()} ${state.message}',
            ),
          );
        } else {
          return Center(child: Text(LocaleKeys.unexpected_cart_error.tr()));
        }
      },
    );
  }
}