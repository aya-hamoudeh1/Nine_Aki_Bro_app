part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

/// Get Data
final class GetDataLoading extends HomeState {}

final class GetDataSuccess extends HomeState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;

  GetDataSuccess({required this.products, required this.categories});

  List<Object> get props => [products, categories];
}

final class GetDataError extends HomeState {}

/// Add To Favorite
final class AddToFavoriteLoading extends HomeState {}

final class AddToFavoriteSuccess extends HomeState {}

final class AddToFavoriteError extends HomeState {}

/// Remove From Favorite
final class RemoveFavoriteLoading extends HomeState {}

final class RemoveFavoriteSuccess extends HomeState {}

final class RemoveFavoriteError extends HomeState {}

/// Add To Cart
class AddToCartLoading extends HomeState {}

class AddToCartSuccess extends HomeState {}

class AddToCartError extends HomeState {}

/// Remove From Cart
class RemoveFromCartLoading extends HomeState {}

class RemoveFromCartSuccess extends HomeState {}

class RemoveFromCartError extends HomeState {}

/// Get Cart Item
class GetCartItemLoading extends HomeState {}

class GetCartItemSuccess extends HomeState {}

class GetCartItemError extends HomeState {}

/// Buy Product
final class BuyProductLoading extends HomeState {}

final class BuyProductSuccess extends HomeState {}

final class BuyProductError extends HomeState {}

/// Get Category Products
final class GetCategoryProductLoading extends HomeState {}

final class GetCategoryProductSuccess extends HomeState {}

final class GetCategoryProductFailure extends HomeState {
  final String errMessage;
  GetCategoryProductFailure({required this.errMessage});
}
