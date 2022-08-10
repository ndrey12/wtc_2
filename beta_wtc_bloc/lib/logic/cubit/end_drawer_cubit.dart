import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'end_drawer_state.dart';

class EndDrawerCubit extends Cubit<EndDrawerState> {
  EndDrawerCubit() : super(EndDrawerInitial());

  void openLogin() {
    emit(EndDrawerLoginState());
  }

  void openRegister() {
    emit(EndDrawerRegisterState());
  }

  void openChangePassword() {
    emit(EndDrawerChangePasswordState());
  }

  void openChangeEmail() {
    emit(EndDrawerChangeEmailState());
  }

  void openForgotPassword() {
    emit(EndDrawerForgotPasswordState());
  }
}
