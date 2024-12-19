import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/homeMenu_select.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/app_bar.dart';

// ignore: must_be_immutable
class SuggestionsScreen extends StatelessWidget {
  SuggestionsScreen({super.key});
  TextEditingController controllerNote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "Suggestions".tr),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 10,
            ),
            Image.asset(
              "assets/icons/tip1.png",
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 247,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 50, left: 10, right: 10),
                        child: TextField(
                          controller: controllerNote,
                          minLines: 6,
                          maxLines: 6,
                          decoration: InputDecoration(
                              hintText:
                                  "Write your opinion or suggestion here...".tr,
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 130),
                                child: Image.asset(
                                  "assets/icons/pen.png",
                                  height: 24,
                                ),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonAll(
                color: Theme.of(context).primaryColor,
                function: () {},
                title: "Send Your Suggestion".tr,
              ),
            )
          ],
        ),
      ),
    );
  }
}
