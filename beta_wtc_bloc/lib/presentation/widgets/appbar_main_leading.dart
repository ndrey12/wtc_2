import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarMainLeading extends StatelessWidget {
  const AppBarMainLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<WatcherListCubit>(context).addNewCoin();
              },
              child: Row(children: const [
                Icon(
                  Icons.add,
                  color: Color(0xFF847968),
                ),
                Text(
                  'Coins',
                  style: TextStyle(
                    color: Color(0xFF847968),
                  ),
                ),
              ]),
            );
          },
        ),
        // Your widgets here
      ],
    );
  }
}
