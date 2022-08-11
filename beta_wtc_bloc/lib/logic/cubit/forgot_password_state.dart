part of 'forgot_password_cubit.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordCanSubmit extends ForgotPasswordState {}

class ForgotPasswordCantSubmit extends ForgotPasswordState {}

class ForgotPasswordRes extends ForgotPasswordState {
  final ChangePasswordStatus changePasswordStatus;
  ForgotPasswordRes({required this.changePasswordStatus});
}
