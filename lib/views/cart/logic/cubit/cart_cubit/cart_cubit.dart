import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/api/api_services.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/models/product_variants_model.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  final ApiServices _apiServices = ApiServices();
  final String userId = Supabase.instance.client.auth.currentUser!.id;

  /// Load Cart
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final response = await _apiServices.getData(
        'cart?for_user=eq.$userId&select=*,products(*),product_variants(*)',
      );

      if (response.data == null || response.data.isEmpty) {
        emit(CartLoaded(const []));
        return;
      }

      final items =
          response.data.map<ProductModel>((item) {
            final product = ProductModel.fromJson(item['products']);
            product.quantity = item['quantity'];

            // **[NEW]** Attach the specific variant to the product model
            if (item['product_variants'] != null) {
              // Create a temporary list containing only the selected variant
              product.variants = [
                ProductVariantModel.fromJson(item['product_variants']),
              ];
            }
            return product;
          }).toList();

      emit(CartLoaded(items));
    } catch (e) {
      log('Failed to load cart: $e');
      emit(CartError('Failed to load cart: $e'));
    }
  }

  /// **[UPDATED]** Add To Cart with a specific variant
  Future<void> addToCart(
    ProductModel product,
    ProductVariantModel variant,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      // Check if the exact same variant already exists in the cart
      final existingItemIndex = currentState.items.indexWhere(
        (p) =>
            p.productId == product.productId &&
            p.variants.isNotEmpty &&
            p.variants.first.variantId == variant.variantId,
      );

      if (existingItemIndex != -1) {
        // If it exists, just update the quantity
        final existingItem = currentState.items[existingItemIndex];
        await _apiServices.patchData(
          'cart?for_user=eq.$userId&for_product_variant=eq.${variant.variantId}',
          {'quantity': existingItem.quantity + 1},
        );
      } else {
        // If not, add a new entry
        await _apiServices.postData('cart', {
          'for_user': userId,
          'for_product': product.productId,
          'for_product_variant': variant.variantId,
          'quantity': 1,
        });
      }
      // Reload the cart to reflect changes
      await loadCart();
    }
  }

  /// Checkout Cart
  Future<void> checkoutCart() async {
    emit(CartCheckoutLoading());
    try {
      final response = await _apiServices.getData(
        'cart?for_user=eq.$userId&select=*,products(*)',
      );

      final items =
          response.data.map<ProductModel>((item) {
            final product = ProductModel.fromJson(item['products']);
            product.quantity = item['quantity'];
            return product;
          }).toList();

      for (var item in items) {
        await _apiServices.postData('purchase', {
          "for_user": userId,
          "is_bought": true,
          "for_product": item.productId,
        });
      }

      await _apiServices.deleteData('cart?for_user=eq.$userId');

      emit(CartCheckoutSuccess());
    } catch (e, stackTrace) {
      log('Checkout error: $e');
      log('StackTrace: $stackTrace');

      if (e.toString().contains("Timeout") ||
          e.toString().contains("Network")) {
        emit(CartCheckoutError("Network error. Please try again."));
      } else {
        emit(CartCheckoutError("Checkout failed. Please try again."));
      }
    }
  }

  /// Increment Quantity
  void incrementQuantity(ProductModel product) {
    if (state is CartLoaded) {
      final items = List<ProductModel>.from((state as CartLoaded).items);
      final index = items.indexWhere(
        (p) =>
            p.productId == product.productId &&
            p.variants.first.variantId == product.variants.first.variantId,
      );

      if (index != -1) {
        final updatedProduct = items[index];
        updatedProduct.quantity += 1;
        items[index] = updatedProduct;

        emit(CartLoaded(items));

        _apiServices.patchData(
          'cart?for_user=eq.$userId&for_product_variant=eq.${updatedProduct.variants.first.variantId}',
          {'quantity': updatedProduct.quantity},
        );
      }
    }
  }

  /// Decrement Quantity
  void decrementQuantity(ProductModel product) {
    if (state is CartLoaded) {
      final items = List<ProductModel>.from((state as CartLoaded).items);
      final index = items.indexWhere(
        (p) =>
            p.productId == product.productId &&
            p.variants.first.variantId == product.variants.first.variantId,
      );

      if (index != -1) {
        final updatedProduct = items[index];
        if (updatedProduct.quantity > 1) {
          updatedProduct.quantity -= 1;
          items[index] = updatedProduct;

          emit(CartLoaded(items));

          _apiServices.patchData(
            'cart?for_user=eq.$userId&for_product_variant=eq.${updatedProduct.variants.first.variantId}',
            {'quantity': updatedProduct.quantity},
          );
        } else {
          deleteItemFromCart(updatedProduct);
        }
      }
    }
  }

  /// Delete Item From Cart
  void deleteItemFromCart(ProductModel product) {
    if (state is CartLoaded) {
      final items = List<ProductModel>.from((state as CartLoaded).items)
        ..removeWhere(
          (p) =>
              p.productId == product.productId &&
              p.variants.first.variantId == product.variants.first.variantId,
        );

      emit(CartLoaded(items));

      _apiServices.deleteData(
        'cart?for_user=eq.$userId&for_product_variant=eq.${product.variants.first.variantId}',
      );
    }
  }
}
