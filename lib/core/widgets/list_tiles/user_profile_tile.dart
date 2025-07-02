import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../views/auth/logic/cubit/authentication_cubit.dart';
import '../../../views/auth/logic/models/user_model.dart';
import '../../../views/auth/ui/login/login_view.dart';
import '../../constants/colors.dart';
import '../images/t_circular_image.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        UserDataModel? userDataModel =
            context.read<AuthenticationCubit>().userDataModel;
        return state is LogoutLoading || state is GetUserDataLoading
            ? const Center(child: CircularProgressIndicator())
            : ListTile(
                leading: const TCircularImage(
                  image: "assets/images/user.png",
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  userDataModel?.name ?? 'User Name',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: TColors.white),
                ),
                subtitle: Text(
                  userDataModel?.email ?? 'User Email',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                ),
                trailing: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Iconsax.edit,
                    color: TColors.white,
                  ),
                ),
              );
      },
    );
  }
}
