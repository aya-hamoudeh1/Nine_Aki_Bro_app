import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingCubit extends Cubit<int> {
  final PageController pageController = PageController();

  OnBoardingCubit() : super(0);

  void goToPage(int index) {
    pageController.animateToPage(index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(index);
  }

  void nextPage() {
    if (state < 2) {
      goToPage(state + 1);
    }
  }

  void skip() {
    goToPage(2);
  }
}




