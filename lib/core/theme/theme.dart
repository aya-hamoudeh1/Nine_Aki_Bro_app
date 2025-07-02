import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/check_box_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData getLightTheme(BuildContext context) {
    final String languageCode = _getCurrentLanguageCode(context);
    final String currentFontFamily =
        (languageCode == 'ar') ? 'Zain' : 'Playfair Display';

    double fontSizeAdjustmentFactor = 1.0;
    if (languageCode == 'ar') {
      fontSizeAdjustmentFactor = 1.15;
    }

    return ThemeData(
      useMaterial3: true,
      fontFamily: currentFontFamily,
      brightness: Brightness.light,
      primaryColor: TColors.primary,
      textTheme: TTextTheme.lightTextTheme.apply(
        fontFamily: currentFontFamily,
        fontSizeFactor: fontSizeAdjustmentFactor,
      ),
      chipTheme: TChipTheme.lightChipTheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: TAppBarTheme.lightTAppBarTheme,
      checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    final String languageCode = _getCurrentLanguageCode(context);
    final String currentFontFamily =
        (languageCode == 'ar') ? 'Zain' : 'Playfair Display';

    double fontSizeAdjustmentFactor = 1.0;
    if (languageCode == 'ar') {
      fontSizeAdjustmentFactor = 1.15;
    }

    return ThemeData(
      useMaterial3: true,
      fontFamily: currentFontFamily,
      disabledColor: TColors.grey,
      brightness: Brightness.dark,
      primaryColor: TColors.primary,
      textTheme: TTextTheme.darkTextTheme.apply(
        fontFamily: currentFontFamily,
        fontSizeFactor: fontSizeAdjustmentFactor,
      ),
      chipTheme: TChipTheme.darkChipTheme,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: TAppBarTheme.darkTAppBarTheme,
      checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    );
  }

  static _getCurrentLanguageCode(BuildContext context) {
    return context.locale.languageCode;
  }
}
