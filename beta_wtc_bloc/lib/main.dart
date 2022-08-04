import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/coin_search_cubit.dart';
import 'package:beta_wtc_bloc/logic/cubit/coin_price_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinSearchCubit>(
          create: (BuildContext context) => CoinSearchCubit(),
        ),
        BlocProvider<WatcherListCubit>(
          create: (BuildContext context) => WatcherListCubit(),
        ),
        BlocProvider<CoinPriceCubit>(
          create: (BuildContext context) => CoinPriceCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Watch The Crypto1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: AppColors.brownDark,
            onPrimary: AppColors.greyDark,
            background: AppColors.brownDark,
            onBackground: Colors.black,
            secondary: AppColors.brownDark,
            onSecondary: AppColors.brownDark,
            error: Colors.black,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
