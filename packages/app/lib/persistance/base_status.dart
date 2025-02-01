import 'package:tedbook/model/message.dart';

enum StatusType {
  initial,
  loading,
  refreshing,
  paging,
  success,
  sending,
  sent,
  updated,
  logout,
  error,
}

/// BaseStatus with [StatusType] and [String] message
class BaseStatus {
  final StatusType type;
  final Message? message;

  const BaseStatus({
    required this.type,
    this.message,
  });

  BaseStatus copyWith({
    StatusType? type,
    Message? message,
  }) {
    return BaseStatus(
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  factory BaseStatus.initial() {
    return const BaseStatus(
      type: StatusType.initial,
    );
  }

  factory BaseStatus.loading() {
    return BaseStatus(
      type: StatusType.loading,
    );
  }

  factory BaseStatus.success() {
    return BaseStatus(
      type: StatusType.success,
    );
  }

  factory BaseStatus.refreshing() {
    return BaseStatus(
      type: StatusType.refreshing,
    );
  }

  factory BaseStatus.paging() {
    return BaseStatus(
      type: StatusType.paging,
    );
  }

  factory BaseStatus.sending() {
    return BaseStatus(
      type: StatusType.sending,
    );
  }

  factory BaseStatus.sent() {
    return BaseStatus(
      type: StatusType.sent,
    );
  }

  factory BaseStatus.updated() {
    return BaseStatus(
      type: StatusType.updated,
    );
  }

  factory BaseStatus.logout() {
    return BaseStatus(
      type: StatusType.logout,
    );
  }

  factory BaseStatus.errorWithMessage({
    required Message? message,
  }) {
    return BaseStatus(
      type: StatusType.error,
      message: message,
    );
  }

  factory BaseStatus.errorWithString({
    required String? message,
  }) {
    return BaseStatus(
      type: StatusType.error,
      message: Message(
        text: message,
        code: 0,
      ),
    );
  }

  bool isLoading() => type == StatusType.loading;

  bool isRefreshing() => type == StatusType.refreshing;

  bool isPaging() => type == StatusType.paging;

  bool isSuccess() => type == StatusType.success;

  bool isError() => type == StatusType.error;

  bool isInitial() => type == StatusType.initial;
}
