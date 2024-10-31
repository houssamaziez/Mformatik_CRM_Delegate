import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/myapp.dart';

class ButtonAll extends StatelessWidget {
  const ButtonAll(
      {super.key,
      required this.function,
      required this.title,
      this.height = 50,
      this.isloading = false});

  final Function function;
  final String title;
  final bool isloading;
  final double height;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isloading) {
        } else {
          function();
        }
      },
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Row(
            children: [
              const Spacer(),
              if (isloading == true) spinkitwhite,
              SizedBox(
                width: isloading == true ? 10 : 0,
              ),
              Text(
                isloading == true ? 'Verifying...'.tr : title,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
