import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
part 'promo_slider_state.dart';

class PromoSliderCubit extends Cubit<int> {
  PromoSliderCubit() : super(0);

  void changePage(int index) => emit(index);
}
