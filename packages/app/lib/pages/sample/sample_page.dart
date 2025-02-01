import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedbook/pages/sample/bloc/sample_bloc.dart';
import 'package:tedbook/persistance/text_style_const.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late SampleBloc bloc;

  @override
  void initState() {
    bloc = context.read<SampleBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainUi,
    );
  }

  Widget get _mainUi => Center(
        child: Text(
          "SampleWidget",
          style: TextStyleS.s16w600(),
        ),
      );
}
