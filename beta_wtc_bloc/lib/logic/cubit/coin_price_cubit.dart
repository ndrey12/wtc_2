import 'dart:async';
import 'package:beta_wtc_bloc/logic/cubit/watcher_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:beta_wtc_bloc/network/coin_prices.dart';

part 'coin_price_state.dart';

class CoinPriceCubit extends Cubit<CoinPriceState> {
  List<String> coinNames = ["BTCUSDT"];
  CoinPriceCubit()
      : super(
          CoinPriceState(
            coinPrices: {
              "BTCUSDT": "N/A",
            },
          ),
        ) {
    updateCoinsPrices();
  }
  void updateCoinsPrices() async {
    while (true) {
      try {
        Map<String, String> newCoinPrices = await CoinPrices.get(coinNames);
        emit(CoinPriceState(coinPrices: newCoinPrices));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void setCoinList(List<String> newCoinNames) {
    coinNames = newCoinNames.toSet().toList();
  }
}
