import 'package:beta_wtc_bloc/logic/cubit/end_drawer_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordItemWidget extends StatelessWidget {
  const ChangePasswordItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      child: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              //! de deschis end drawerul dupa ce apelam functia din cubit
              Navigator.pop(context);
              BlocProvider.of<EndDrawerCubit>(context).openChangePassword();
              AppRouter.showEndDrawerScreen();
            },
            child: Row(children: const [
              Icon(
                Icons.edit,
                color: Color(0xFF847968),
              ),
              Text(
                'Change Password',
                style: TextStyle(
                  color: Color(0xFF847968),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
