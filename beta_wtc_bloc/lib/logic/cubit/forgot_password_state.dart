part of 'forgot_password_cubit.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordCanSubmit extends ForgotPasswordState {}

class ForgotPasswordCantSubmit extends ForgotPasswordState {}
