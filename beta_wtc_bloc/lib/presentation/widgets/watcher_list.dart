import 'package:beta_wtc_bloc/logic/cubit/coin_price_cubit.dart';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:beta_wtc_bloc/presentation/widgets/watcher_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatcherList extends StatefulWidget {
  const WatcherList({Key? key}) : super(key: key);

  @override
  State<WatcherList> createState() => _WatcherListState();
}

class _WatcherListState extends State<WatcherList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatcherListCubit, WatcherListState>(
      listener: (context, state) {
        //updatam numele coinurilor carora vrem sa le aflam pretul
        BlocProvider.of<CoinPriceCubit>(context).setCoinList(state.coinNames);
      },
      builder: (context, state) {
        List<String> coinWatchersNames = state.coinNames;

        int listLenght = coinWatchersNames.length;
        int coinsPerLine = getItemsPerLine(listLenght);
        int lines = 0;
        bool difLine = false;
        if (listLenght % coinsPerLine == 0) {
          lines = listLenght ~/ coinsPerLine;
        } else {
          difLine = true;
          lines = listLenght ~/ coinsPerLine + 1;
        }

        //debugPrint(lines.toString());

        List<Widget> rows = [];
        int id = -1;
        for (int line = 1; line <= lines; line++) {
          List<String> lineCoins = [];
          int startPos = (line - 1) * coinsPerLine;
          int endPos = line * coinsPerLine;
          if (difLine == true && line == lines) {
            endPos = listLenght;
          }
          for (int i = startPos; i < endPos; i++) {
            lineCoins.add(coinWatchersNames[i]);
          }
          rows.add(Row(
            children: [
              ...lineCoins.map((currentCoin) {
                id++;
                return Expanded(
                  child: WatcherItem(
                      coinId: id,
                      coinName: currentCoin,
                      lines: lines,
                      columns: coinsPerLine),
                );
              })
            ],
          ));
        }
        return Column(
          children: [
            ...rows.map((currentRow) {
              return Expanded(
                child: currentRow,
              );
            })
          ],
        );
      },
    );
  }
}

double getFitRatio(
    int listLenght, int itemsPerLine, double width, double height) {
  int columns = listLenght ~/ itemsPerLine;
  if (listLenght % itemsPerLine == 0) {
    columns = listLenght ~/ itemsPerLine;
  } else {
    columns = listLenght ~/ itemsPerLine + 1;
  }

  double itemWidth = width / itemsPerLine.toDouble();
  double itemHeight = height / columns;
  if (itemHeight > itemWidth) return itemHeight / itemWidth;
  return itemWidth / itemHeight;
}

int getItemsPerLine(int listLenght) {
  Size size = WidgetsBinding.instance.window.physicalSize;
  double width = size.width;
  double height = size.height;

  int bestFit = 1;
  double bestFitRatio = getFitRatio(listLenght, 1, width, height);
  for (int i = 2; i <= listLenght; i++) {
    double currentFitRatio = getFitRatio(listLenght, i, width, height);
    //debugPrint(currentFitRatio.toString());
    if ((1 - currentFitRatio).abs() < (1 - bestFitRatio).abs()) {
      bestFit = i;
      bestFitRatio = currentFitRatio;
    }
  }
  return bestFit;
}
