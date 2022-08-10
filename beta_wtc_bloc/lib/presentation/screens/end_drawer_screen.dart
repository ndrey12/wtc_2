import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/end_drawer_cubit.dart';
import 'package:beta_wtc_bloc/presentation/widgets/login_end_drawer.dart';
import 'package:beta_wtc_bloc/presentation/widgets/register_end_drawer.dart';
import 'package:beta_wtc_bloc/presentation/widgets/change_password_end_drawer.dart';
import 'package:beta_wtc_bloc/presentation/widgets/change_email_end_drawer.dart';
import 'package:beta_wtc_bloc/presentation/widgets/forgot_password_end_drawer.dart';

class EndDrawerScreen extends StatefulWidget {
  EndDrawerScreen({Key? key}) : super(key: key);

  @override
  State<EndDrawerScreen> createState() => _EndDrawerScreenState();
}

class _EndDrawerScreenState extends State<EndDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EndDrawerCubit, EndDrawerState>(
      builder: (context, state) {
        if (state is EndDrawerLoginState) {
          return LoginEndDrawer();
        } else if (state is EndDrawerRegisterState) {
          return RegisterEndDrawer();
        } else if (state is EndDrawerChangePasswordState) {
          return ChangePasswordEndDrawer();
        } else if (state is EndDrawerChangeEmailState) {
          return ChangeEmailEndDrawer();
        } else if (state is EndDrawerForgotPasswordState) {
          return ForgotPasswordEndDrawer();
        }
        AppRouter.hideEndDrawerScreen();
        return const Text("Please refresh");
      },
      listener: (context, state) {},
    );
  }
}
