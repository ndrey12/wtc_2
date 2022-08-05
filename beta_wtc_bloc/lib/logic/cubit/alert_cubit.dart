import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());
  void showAlert(String title, String message) {
    emit(AlertShow(title: title, message: message));
  }
}
