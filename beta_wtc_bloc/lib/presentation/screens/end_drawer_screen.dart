import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/end_drawer_cubit.dart';
import 'package:beta_wtc_bloc/presentation/widgets/login_end_drawer.dart';
import 'package:beta_wtc_bloc/presentation/widgets/register_end_drawer.dart';

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
          debugPrint("miau loginescu");
          return LoginEndDrawer();
        } else if (state is EndDrawerRegisterState) {
          debugPrint("miau registerescu");
          return RegisterEndDrawer();
        }
        debugPrint("miau papa");
        AppRouter.hideEndDrawerScreen();
        return const Text("Please refresh");
      },
      listener: (context, state) {},
    );
  }
}
