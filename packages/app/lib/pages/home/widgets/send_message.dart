import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/persistance/base_status.dart';
import 'package:tedbook/widgets/custom_text_field.dart';

class SendMessage extends StatelessWidget {
  final String orderId;

  const SendMessage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    late HomeBloc bloc = context.read<HomeBloc>();

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.status.type != current.status.type,
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12)
              .copyWith(bottom: 0),
          child: Row(
            children: [
              Flexible(
                child: CustomTextField(
                  controller: bloc.commentControllers[orderId],
                  focusNode: bloc.commentFocuses[orderId],
                  height: 44,
                  hintText: "Отправить",
                ),
              ),
              SizedBox(width: 16),
              InkWell(
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  bloc.add(SendCommentEvent(orderId: orderId));
                },
                child: state.status.type == StatusType.loading
                    ? CircularProgressIndicator()
                    : SvgPicture.asset("assets/icons/send.svg"),
              ),
            ],
          ),
        );
      },
    );
  }
}
