import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsCard extends StatelessWidget {
  final String address;
  final String phone;

  const ContactsCard({super.key, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri(
          scheme: 'tel',
          path: phone,
        ));
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  address,
                  style: TextStyleS.s12w400(color: AppColor.textGreyColor),
                ),
                SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyleS.s12w600(),
                ),
              ],
            ),
            SvgPicture.asset("assets/icons/phone.svg"),
          ],
        ),
        decoration: BoxDecoration(
          color: AppColor.scaffoldBackColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Color(0xFFDDDDDD)),
        ),
      ),
    );
  }
}
