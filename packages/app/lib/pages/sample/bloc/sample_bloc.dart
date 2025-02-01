import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedbook/persistance/base_status.dart';

part 'sample_event.dart';

part 'sample_state.dart';

class SampleBloc extends Bloc<SampleEvent, SampleState> {
  SampleBloc() : super(SampleState.initial()) {}

// final ApiProvider _apiProvider = getInstance();
// final UserData _userData = getInstance();
}
