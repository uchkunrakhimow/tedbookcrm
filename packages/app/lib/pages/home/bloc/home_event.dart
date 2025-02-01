part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InitEvent extends HomeEvent {}

class RefreshEvent extends HomeEvent {}

class ChangeOrderTypeEvent extends HomeEvent {
  final int selectedTypeIndex;

  ChangeOrderTypeEvent({required this.selectedTypeIndex});
}

class SendCommentEvent extends HomeEvent {
  final String orderId;

  SendCommentEvent({required this.orderId});
}

class InputAmountEvent extends HomeEvent {
  final String method;
  final double amount;

  InputAmountEvent({
    required this.method,
    required this.amount,
  });
}

class IsExpandedEvent extends HomeEvent {
  final String orderId;
  final bool isExp;

  IsExpandedEvent({
    required this.orderId,
    required this.isExp,
  });
}

class OrderCompletionEvent extends HomeEvent {
  final String orderId;
  final String status;

  OrderCompletionEvent({required this.orderId, required this.status});
}

class LogoutEvent extends HomeEvent {}
