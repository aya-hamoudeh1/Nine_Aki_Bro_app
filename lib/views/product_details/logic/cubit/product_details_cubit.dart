import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/api/api_services.dart';
import '../../../product_reviews/logic/models/rate_model.dart';
part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductRateInitial());

  final ApiServices _apiServices = ApiServices();
  String userId = Supabase.instance.client.auth.currentUser!.id;

  List<RatingModel> rates = [];
  int averageRate = 0;
  int userRate = 5;

  Future<void> getRates({required String productId}) async {
    emit(GetRateLoading());
    try {
      Response response = await _apiServices
          .getData('rates?select=*&for_product=eq.$productId');
      for (var rate in response.data) {
        rates.add(RatingModel.fromJson(rate));
      }
      _getAverageMethod();
      _getUserRate();
      emit(GetRateSuccess());
    } catch (e) {
      log(e.toString());
      emit(GetRateError());
    }
  }

  void _getUserRate() {
    List<RatingModel> userRates =
        rates.where((RatingModel rate) => rate.forUser == userId).toList();
    if (userRates.isNotEmpty) {
      userRate = userRates[0].rate!;
    }
  }

  void _getAverageMethod() {
    for (var userRate in rates) {
      if (userRate.rate != null) {
        averageRate += userRate.rate!;
      }
    }
    if (rates.isNotEmpty) {
      averageRate = averageRate ~/ rates.length;
    }
  }

  bool _isUserRateExist({required String productId}) {
    for (var rate in rates) {
      if ((rate.forUser == userId) && (rate.forProduct == productId)) {
        return true;
      }
    }
    return false;
  }

  Future<void> addOrUpdateUserRate(
      {required String productId, required Map<String, dynamic> data}) async {
    /// user rate exist ==> update for user rate
    /// user rate doesn't exist ==> add rate
    String path =
        'rates?select=*&for_user=eq.$userId&for_product=eq.$productId';
    emit(AddOrUpdateRateLoading());
    try {
      if (_isUserRateExist(productId: productId)) {
        /// patch rate
        await _apiServices.patchData(path, data);
      } else {
        /// post rate
        await _apiServices.postData(path, data);
      }
      emit(AddOrUpdateRateSuccess());
    } catch (e) {
      log(e.toString());
      emit(AddOrUpdateRateError());
    }
  }

  Future<void> addComment({required Map<String, dynamic> data}) async {
    emit(AddCommentLoading());
    try {
      await _apiServices.postData('comments', data);
      emit(AddCommentSuccess());
    } catch (e) {
      log(e.toString());
      emit(AddCommentError());
    }
  }
}
