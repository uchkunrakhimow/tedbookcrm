part of 'sample_bloc.dart';

@immutable
class SampleState {
  final BaseStatus loginStatus;

  SampleState({required this.loginStatus});

  factory SampleState.initial() {
    return SampleState(loginStatus: BaseStatus.initial());
  }

  SampleState copyWith({BaseStatus? loginStatus}) {
    return SampleState(loginStatus: loginStatus ?? this.loginStatus);
  }
}
