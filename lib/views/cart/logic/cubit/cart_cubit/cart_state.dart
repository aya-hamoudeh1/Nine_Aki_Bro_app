part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

/// Cart
class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<ProductModel> items;

  CartLoaded(this.items);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (previousValue, item) {
    final price = double.tryParse(item.price?.toString() ?? '0.0') ?? 0.0;
    final quantity = item.quantity;
    return previousValue + (price * quantity);
  });
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

/// Cart Checkout
class CartCheckoutLoading extends CartState {}

class CartCheckoutSuccess extends CartState {}

class CartCheckoutError extends CartState {
  final String message;
  CartCheckoutError(this.message);
}
