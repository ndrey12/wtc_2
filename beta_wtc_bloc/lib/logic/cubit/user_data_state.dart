part of 'user_data_cubit.dart';

@immutable
abstract class UserDataState {
  bool isConnected = false;
}

class UserDataInitial extends UserDataState {
  UserDataInitial() {
    isConnected = false;
  }
}

class UserDataRegisterState extends UserDataState {
  final RegisterStatus registerStatus;
  UserDataRegisterState({required this.registerStatus}) {
    isConnected = false;
  }
}

class UserDataLoginState extends UserDataState {
  final LoginStatus loginStatus;
  final List<String> coinNames;
  UserDataLoginState(
      {required this.loginStatus, required this.coinNames, connected}) {
    isConnected = connected;
  }
}

class UserDataChangePasswordState extends UserDataState {
  final ChangePasswordStatus changePasswordStatus;
  UserDataChangePasswordState({required this.changePasswordStatus}) {
    isConnected = true;
  }
}

class UserDataChangeEmailState extends UserDataState {
  final ChangeEmailStatus changeEmailStatus;
  UserDataChangeEmailState({required this.changeEmailStatus}) {
    isConnected = true;
  }
}
