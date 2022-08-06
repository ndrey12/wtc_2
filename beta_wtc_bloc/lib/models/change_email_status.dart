import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeEmailStatus {
  bool status;
  String message;
  ChangeEmailStatus({required this.status, required this.message});
}
