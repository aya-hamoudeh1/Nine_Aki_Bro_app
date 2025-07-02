part of 'product_details_cubit.dart';

@immutable
sealed class ProductDetailsState {}

final class ProductRateInitial extends ProductDetailsState {}

/// Get Rate
final class GetRateLoading extends ProductDetailsState {}

final class GetRateSuccess extends ProductDetailsState {}

final class GetRateError extends ProductDetailsState {}

/// Add Or Update Rate
final class AddOrUpdateRateLoading extends ProductDetailsState {}

final class AddOrUpdateRateSuccess extends ProductDetailsState {}

final class AddOrUpdateRateError extends ProductDetailsState {}

/// Add Comment
final class AddCommentLoading extends ProductDetailsState {}

final class AddCommentSuccess extends ProductDetailsState {}

final class AddCommentError extends ProductDetailsState {}
