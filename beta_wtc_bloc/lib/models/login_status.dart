import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/models/user_data.dart';

class LoginStatus {
  UserData userData;
  bool status;
  String message;
  LoginStatus(
      {required this.userData, required this.status, required this.message});
}
