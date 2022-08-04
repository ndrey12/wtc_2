import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';

class DrawerScreenItem extends StatelessWidget {
  final String coinName;
  const DrawerScreenItem({Key? key, required this.coinName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.add,
      ),
      title: Text(coinName),
      onTap: () {
        BlocProvider.of<WatcherListCubit>(context).changeCoin(coinName);
        Navigator.pop(context);
      },
    );
  }
}
