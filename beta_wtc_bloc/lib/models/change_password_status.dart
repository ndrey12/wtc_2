import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordStatus {
  bool status;
  String message;
  ChangePasswordStatus({required this.status, required this.message});
}
