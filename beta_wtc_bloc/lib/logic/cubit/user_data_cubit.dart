import 'package:beta_wtc_bloc/models/change_email_status.dart';
import 'package:beta_wtc_bloc/models/register_status.dart';
import 'package:beta_wtc_bloc/models/login_status.dart';
import 'package:beta_wtc_bloc/models/user_coins_status.dart';
import 'package:beta_wtc_bloc/models/change_password_status.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:beta_wtc_bloc/models/user_data.dart';
import 'package:beta_wtc_bloc/network/user_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:flutter/material.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  bool isConnected = false;
  late UserData userData;
  UserDataCubit() : super(UserDataInitial());

  Future<void> registerAccount(
      String username, String password, String email) async {
    RegisterStatus registerStatus =
        await UserFunctions.registerUser(username, password, email);
    emit(UserDataRegisterState(registerStatus: registerStatus));
  }

  Future<void> loginAccount(String username, String password) async {
    LoginStatus loginStatus = await UserFunctions.loginUser(username, password);
    if (loginStatus.status == true) {
      isConnected = true;
      userData = loginStatus.userData;
      //!De incarcat din baza de date coinurile urmarite
      UserCoinsStatus userCoinsStatus =
          await UserFunctions.getCoinsForUser(userData.token);
      emit(UserDataLoginState(
          loginStatus: loginStatus,
          coinNames: userCoinsStatus.userCoins,
          connected: true));
    } else {
      emit(UserDataLoginState(
          loginStatus: loginStatus, coinNames: [], connected: false));
    }
  }

  void setCoinList(List<String> newCoinList) {
    if (isConnected == true) {
      UserFunctions.updateCoinsForUser(userData.token, newCoinList);
      //!Update in data base
    }
  }

  void logOut() {
    if (isConnected == true) {
      isConnected = false;
      emit(UserDataInitial());
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    ChangePasswordStatus changePasswordStatus =
        await UserFunctions.changePassword(
            userData.token, oldPassword, newPassword);
    emit(UserDataChangePasswordState(
        changePasswordStatus: changePasswordStatus));
  }

  Future<void> changeEmail(String password, String email) async {
    ChangeEmailStatus changeEmailStatus =
        await UserFunctions.changeEmail(userData.token, password, email);
    if (changeEmailStatus.status == true) {
      userData.email = email;
    }
    emit(UserDataChangeEmailState(changeEmailStatus: changeEmailStatus));
  }
}
