import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWathcerLeading extends StatelessWidget {
  final String coinName;
  final int coinId;
  const AppBarWathcerLeading(
      {Key? key, required this.coinName, required this.coinId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            //adaugare la bloc ca acest watcher a apelat change coin
            BlocProvider.of<WatcherListCubit>(context)
                .setChangingCoinPos(coinId);
            AppRouter.showDrawerScreen();
          },
          child: Row(
            children: [
              Stack(
                children: [
                  AutoSizeText(
                    coinName,
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = const Color(0xFF222222),
                    ),
                    maxLines: 1,
                  ),
                  // Solid text as fill.
                  AutoSizeText(
                    coinName,
                    style: const TextStyle(
                      color: Color(0xFF847968),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              Icon(Icons.edit, color: AppColors.brownDark),
            ],
          ),
        );
      },
    );
  }
}
