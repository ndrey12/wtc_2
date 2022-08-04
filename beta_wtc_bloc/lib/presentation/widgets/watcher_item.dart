import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/presentation/widgets/appbar_watcher.dart';
import 'package:beta_wtc_bloc/presentation/widgets/watcher_price.dart';

class WatcherItem extends StatefulWidget {
  final String coinName;
  final int coinId;
  final int lines;
  final int columns;
  const WatcherItem(
      {Key? key,
      required this.coinName,
      required this.coinId,
      required this.lines,
      required this.columns})
      : super(key: key);

  @override
  State<WatcherItem> createState() => _WatcherItemState();
}

class _WatcherItemState extends State<WatcherItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF222222),
        ),
      ),
      child: Scaffold(
          backgroundColor: AppColors.greyLight,
          appBar: AppBarWatcher(
            coinName: widget.coinName,
            coinId: widget.coinId,
          ), // de adaugat x
          body: WatcherPriceWidget(
              coinName: widget.coinName,
              columns: widget.columns,
              lines: widget.lines)),
    );
  }
}
