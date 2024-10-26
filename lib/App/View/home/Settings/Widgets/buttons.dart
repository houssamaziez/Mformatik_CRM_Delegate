import 'package:flutter/material.dart';

Padding buttonsetting({
  required String title,
  required String image,
  function,
  Color color = const Color(0xffF5F6FA),
  Color colortext = Colors.black,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: color, borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                image,
                height: 24,
                width: 24,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w400, color: colortext),
            ),
          ],
        ),
      ),
    ),
  );
}
