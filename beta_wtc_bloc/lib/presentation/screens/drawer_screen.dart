import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/logic/cubit/coin_search_cubit.dart';
import 'package:beta_wtc_bloc/presentation/widgets/drawer_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/widgets/searchbar.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.brownDark,
            child: Column(children: [
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF847968),
                  ),
                  onPressed: () {
                    AppRouter.hideDrawerScreen();
                  },
                ),
              ),
              SearchBar(
                onChanged: (String query) {
                  BlocProvider.of<CoinSearchCubit>(context).search(query);
                },
              ),
            ]),
          ),
          BlocConsumer<CoinSearchCubit, CoinSearchState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  ...state.coinNames.map((currentCoinName) {
                    return DrawerScreenItem(coinName: currentCoinName);
                  })
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
