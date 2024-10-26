import 'package:flutter/material.dart';

extension CustomTextStyle on String {
  Text style(
      {Color color = Colors.black,
      double? fontSize = 12,
      TextAlign? textAlign = TextAlign.start,
      FontWeight fontWeight = FontWeight.w500}) {
    return Text(
      this,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  Text styletitle(
      {Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w500}) {
    return Text(
      this,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
