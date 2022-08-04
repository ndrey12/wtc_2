import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'watcher_list_state.dart';

class WatcherListCubit extends Cubit<WatcherListState> {
  List<String> coinNames = ["BTCUSDT"];
  int changingCoinPos = -1;
  WatcherListCubit() : super(WatcherListState(coinNames: ["BTCUSDT"]));
  void addNewCoin() {
    coinNames.add("BTCUSDT");
    resetChangingCoinPos();
    emit(WatcherListState(coinNames: coinNames));
  }

  void setChangingCoinPos(int newPos) {
    changingCoinPos = newPos;
  }

  void changeCoin(String newCoinName) {
    if (changingCoinPos != -1) {
      coinNames[changingCoinPos] = newCoinName;
      emit(WatcherListState(coinNames: coinNames));
      changingCoinPos = -1;
    }
  }

  void resetChangingCoinPos() {
    changingCoinPos = -1;
  }

  void deleteCoin(int coinPos) {
    if (coinPos >= 0 && coinPos < coinNames.length && coinNames.length > 1) {
      coinNames.removeAt(coinPos);
      emit(WatcherListState(coinNames: coinNames));
      resetChangingCoinPos();
    }
  }
}
