import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/presentation/widgets/appbar_watcher_leading.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWatcher extends StatelessWidget implements PreferredSizeWidget {
  final String coinName;
  final int coinId;
  const AppBarWatcher({Key? key, required this.coinName, required this.coinId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50.0,
      backgroundColor: AppColors.brownDark2,
      automaticallyImplyLeading: false,
      title: AppBarWathcerLeading(coinName: coinName, coinId: coinId),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<WatcherListCubit>(context).deleteCoin(coinId);
          },
          icon: const Icon(
            Icons.close,
            color: Color(0xFF847968),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
