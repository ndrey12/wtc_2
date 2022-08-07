import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  late String paramToken;
  ForgotPasswordCubit() : super(ForgotPasswordInitial());
  void setParamToken(String newParamToken) {
    paramToken = newParamToken;
  }
}
