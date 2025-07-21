import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/views/address/logic/cubit/address_cubit.dart';
import 'package:nine_aki_bro_app/views/address/logic/repos/address_repo.dart';
import 'package:nine_aki_bro_app/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:nine_aki_bro_app/views/cart/logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:nine_aki_bro_app/views/home/logic/cubit/home_cubit.dart';
import 'package:nine_aki_bro_app/views/notifications/logic/cubit/notification_cubit/notification_cubit.dart';
import 'package:nine_aki_bro_app/views/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/sensitive_data.dart';
import 'core/helpers/bloc_observer.dart';
import 'core/theme/theme.dart';

void main() async {
  /// supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  Bloc.observer = MyObserver();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translation',
      fallbackLocale: Locale('en'),
      startLocale: Locale('ar'),
      saveLocale: true,
      child: const NineAkiBro(),
    ),
  );
}

class NineAkiBro extends StatelessWidget {
  const NineAkiBro({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationCubit()..getUserData()),
        BlocProvider(
          create:
              (_) =>
                  HomeCubit()
                    ..getCategories()
                    ..getProducts(),
        ),
        BlocProvider(create: (_) => NotificationCubit()..fetchNotifications()),
        BlocProvider(create: (_) => CartCubit()..loadCart()),
        BlocProvider(
          create: (_) => AddressCubit(AddressRepository())..fetchAddresses(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Nine Aki Bro',
        themeMode: ThemeMode.system,
        theme: TAppTheme.getDarkTheme(context),
        darkTheme: TAppTheme.getDarkTheme(context),
        home: const SplashScreen(),
      ),
    );
  }
}
