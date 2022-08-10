import 'package:beta_wtc_bloc/models/change_password_status.dart';
import 'package:beta_wtc_bloc/network/user_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:beta_wtc_bloc/models/change_password_status.dart';
import 'package:flutter/material.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  late String paramToken;
  ForgotPasswordCubit() : super(ForgotPasswordCantSubmit());
  void setParamToken(String newParamToken) {
    paramToken = newParamToken;
    debugPrint("aasd");
    emit(ForgotPasswordCanSubmit());
  }

  Future<void> changePassword(String newPassword) async {
    emit(ForgotPasswordCantSubmit());
    ChangePasswordStatus changePasswordStatus =
        await UserFunctions.forgotPassword(paramToken, newPassword);
  }

  void sendForgotPasswordMail(String userEmail) {
    UserFunctions.sendForgotPasswordMail(userEmail);
  }
}
