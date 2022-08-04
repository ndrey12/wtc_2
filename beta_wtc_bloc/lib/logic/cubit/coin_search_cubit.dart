import 'package:beta_wtc_bloc/network/search_coin.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'coin_search_state.dart';

class CoinSearchCubit extends Cubit<CoinSearchState> {
  CoinSearchCubit() : super(CoinSearchState(coinNames: [])) {
    search("USDT");
  }

  void search(String query) async {
    List<String> coinNames;
    if (query == "") {
      query = "USDT";
    }
    coinNames = await SearchCoin.searchCoins(query);
    emit(CoinSearchState(coinNames: coinNames));
  }
}
