import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/logic/cubit/coin_price_cubit.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/widgets/login_item.dart';
import 'package:beta_wtc_bloc/presentation/widgets/register_item.dart';
import 'package:beta_wtc_bloc/presentation/widgets/logout_item.dart';
import 'package:beta_wtc_bloc/presentation/widgets/change_password_item.dart';
import 'package:beta_wtc_bloc/presentation/widgets/change_email_item.dart';
import 'package:beta_wtc_bloc/logic/cubit/user_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/alert_cubit.dart';

class PopUpMenuMain extends StatelessWidget {
  const PopUpMenuMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataCubit, UserDataState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is UserDataRegisterState) {
          if (state.registerStatus.status == true) {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Info", state.registerStatus.message);
          } else {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Error", state.registerStatus.message);
          }
        } else if (state is UserDataLoginState) {
          if (state.loginStatus.status == false) {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Error", state.loginStatus.message);
          } else {
            BlocProvider.of<WatcherListCubit>(context)
                .setCoinNames(state.coinNames);
            BlocProvider.of<CoinPriceCubit>(context)
                .setCoinList(state.coinNames);
          }
        } else if (state is UserDataChangePasswordState) {
          if (state.changePasswordStatus.status == false) {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Error", state.changePasswordStatus.message);
          } else {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Info", state.changePasswordStatus.message);
          }
        } else if (state is UserDataChangeEmailState) {
          if (state.changeEmailStatus.status == false) {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Error", state.changeEmailStatus.message);
          } else {
            BlocProvider.of<AlertCubit>(context)
                .showAlert("Info", state.changeEmailStatus.message);
          }
        }
      },
      builder: (context, state) {
        if (state.isConnected == true) {
          return PopupMenuButton(
            icon: const Icon(Icons.menu),
            color: AppColors.greyLight,
            itemBuilder: (context) => const [
              PopupMenuItem(child: LogoutItemWidget()),
              PopupMenuItem(child: ChangePasswordItemWidget()),
              PopupMenuItem(child: ChangeEmailItemWidget()),
            ],
          );
        }
        return PopupMenuButton(
          icon: const Icon(Icons.menu),
          color: AppColors.greyLight,
          itemBuilder: (context) => const [
            PopupMenuItem(child: LoginItemWidget()),
            PopupMenuItem(child: RegisterItemWidget()),
          ],
        );
      },
    );
  }
}
