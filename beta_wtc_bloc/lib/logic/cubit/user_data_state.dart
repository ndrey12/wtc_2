part of 'user_data_cubit.dart';

@immutable
abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataRegisterState extends UserDataState {
  final RegisterStatus registerStatus;
  UserDataRegisterState({required this.registerStatus});
}
