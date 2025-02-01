part of 'login_bloc.dart';

@immutable
class LoginState {
  final BaseStatus loginStatus;

  LoginState({required this.loginStatus});

  factory LoginState.initial() {
    return LoginState(loginStatus: BaseStatus.initial());
  }

  LoginState copyWith({BaseStatus? loginStatus}) {
    return LoginState(loginStatus: loginStatus ?? this.loginStatus);
  }
}
