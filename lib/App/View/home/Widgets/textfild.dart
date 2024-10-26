import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    super.key,
    required this.namecontroller,
    required this.title,
    required this.suptitle,
    required this.ispassword,
  });

  final TextEditingController namecontroller;
  final String title;
  final String suptitle;
  final bool ispassword;
  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool issee = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            children: [
              TextField(
                controller: widget.namecontroller,
                obscureText: widget.ispassword == false ? false : !issee,
                decoration: InputDecoration(
                    hintText: widget.suptitle, border: InputBorder.none),
              ).paddingAll().expand(),
              if (widget.ispassword)
                IconButton(
                    onPressed: () {
                      setState(() {
                        issee = !issee;
                      });
                    },
                    icon: Image.asset(
                      issee
                          ? 'assets/icons/invisible.png'
                          : 'assets/icons/visible.png',
                      height: 20,
                    )),
            ],
          ),
        ),
      ],
    ).paddingAll(value: 10);
  }
}
