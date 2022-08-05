import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/widgets/login_item.dart';
import 'package:beta_wtc_bloc/presentation/widgets/register_item.dart';

class PopUpMenuMain extends StatelessWidget {
  const PopUpMenuMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: AppColors.greyLight,
      itemBuilder: (context) => [
        PopupMenuItem(child: LoginItemWidget()),
        PopupMenuItem(child: RegisterItemWidget()),
      ],
    );
  }
}
