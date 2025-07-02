part of 'address_cubit.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  final List<AddressModel> addresses;
  AddressSuccess(this.addresses);
}

class AddressFailure extends AddressState {
  final String message;
  AddressFailure(this.message);
}
