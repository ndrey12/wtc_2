import 'package:beta_wtc_bloc/models/register_status.dart';
import 'package:beta_wtc_bloc/models/login_status.dart';
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
  List<String> watcherCoin = ["BTCUSDT"];
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
    }
    emit(UserDataLoginState(loginStatus: loginStatus));
  }
}

//ne jucam cu listenurile dintr-un cubit in altul si aia e, vezi la final explicatie 
//https://stackoverflow.com/questions/59137180/flutter-listen-bloc-state-from-other-bloc