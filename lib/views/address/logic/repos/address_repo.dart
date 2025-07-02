import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/address_model.dart';

class AddressRepository {
  final _supabase = Supabase.instance.client;

  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated.';

      final data = await _supabase
          .from('addresses')
          .select()
          .eq('user_id', userId);

      return (data as List<dynamic>)
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching addresses: $e';
    }
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated.';

      final addressData = {
        'user_id': userId,
        'name': address.name,
        'phone_number': address.phoneNumber,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'postal_code': address.postalCode,
        'country': address.country,
        'is_default': address.isDefault,
      };

      await _supabase.from('addresses').insert(addressData);
    } catch (e) {
      throw 'Failed to add address: $e';
    }
  }

  Future<void> updateDefaultAddress(String addressId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated.';

      await _supabase
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId);

      await _supabase
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId);
    } catch (e) {
      throw "Failed to update default address: $e";
    }
  }
}
