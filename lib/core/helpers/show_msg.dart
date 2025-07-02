import 'package:flutter/material.dart';

import '../constants/colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMsg(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: TColors.white),
      ),
      backgroundColor: TColors.primary,
    ),
  );
}
