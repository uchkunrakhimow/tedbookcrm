import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tedbook/model/response/order_response.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';

class Messages extends StatelessWidget {
  final List<MessageModel> messages;
  const Messages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        MessageModel message = messages[index];
        bool isFirst = index == 0 ||
            messages[index].commenterRole !=
                messages[index - 1].commenterRole;
        return Column(
          children: [
            if (isFirst) SizedBox(height: 8),
            if (index == 0 ||
                DateTime.parse(messages[index].createdAt ?? "").day !=
                    DateTime.parse(messages[index - 1].createdAt ?? "").day)
              Text(
                DateFormat('EEE h:mm a')
                    .format(DateTime.parse(message.createdAt ?? "")),
                style: TextStyleS.s12w500(color: AppColor.textGreyColor),
              ),
            SizedBox(height: 8),
            _messageCard(
              message: message,
              isFirst: isFirst,
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 4),
      itemCount: messages.length,
    );
  }

  Widget _messageCard({
    required MessageModel message,
    required bool isFirst,
  }) {
    bool isOperator = message.commenterRole == "operator";
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
      isOperator ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOperator && isFirst)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset("assets/icons/person.svg"),
          ),
        if (isOperator && !isFirst) SizedBox(width: 40),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30).copyWith(
                topLeft: Radius.circular((isOperator && isFirst) ? 0 : 30),
              ),
              color: isOperator ? AppColor.scaffoldBackColor : AppColor.cardColor,
            ),
            child: Text(
              message.commentText ?? "",
              style: TextStyleS.s16w400(),
            ),
          ),
        ),
      ],
    );
  }
}

