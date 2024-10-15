import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/View/auth/screen_auth.dart';
import '../../../Util/Style/stylecontainer.dart';

Container containerwithblue(BuildContext context,
    {required String widget,
    double height = 48,
    double raduis = 12,
    Color backgColor = Colors.white,
    Color color = const Color(0xff1073BA)}) {
  return Container(
    height: height,
    decoration: StyleContainer.stylecontainer(color: color, raduis: raduis),
    child: Center(
      child: Container(
        decoration:
            StyleContainer.stylecontainer(color: backgColor, raduis: raduis),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: 'sdcfsdcsdcsdc'.style()),
        ),
      ).paddingAll(value: 1),
    ),
  );
}
