part of 'alert_cubit.dart';

@immutable
abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertShow extends AlertState {
  final String title;
  final String message;
  AlertShow({required this.title, required this.message});
}
