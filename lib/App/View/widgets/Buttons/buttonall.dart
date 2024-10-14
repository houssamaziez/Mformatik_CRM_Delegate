import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

class ButtonAll extends StatelessWidget {
  const ButtonAll(
      {super.key,
      required this.function,
      required this.title,
      this.height = 50,
      this.islogin = false});

  final Function function;
  final String title;
  final bool islogin;
  final double height;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (islogin) {
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
              if (islogin == true) spinkitwhite,
              SizedBox(
                width: islogin == true ? 10 : 0,
              ),
              Text(
                islogin == true ? 'جاري التحقق ...' : title,
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
