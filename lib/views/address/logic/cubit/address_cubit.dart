import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../models/address_model.dart';
import '../repos/address_repo.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;

  AddressCubit(this._addressRepository) : super(AddressInitial()) {
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      emit(AddressLoading());
      final addresses = await _addressRepository.fetchUserAddresses();
      emit(AddressSuccess(addresses));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  Future<void> addNewAddress(AddressModel newAddress) async {
    try {
      await _addressRepository.addAddress(newAddress);
      fetchAddresses();
    } catch (e) {
      emit(AddressFailure("Failed to add address: ${e.toString()}"));
    }
  }

  Future<void> selectDefaultAddress(String addressId) async {
    try {
      await _addressRepository.updateDefaultAddress(addressId);
      fetchAddresses();
    } catch (e) {
      emit(AddressFailure("Failed to select default address: ${e.toString()}"));
    }
  }
}
