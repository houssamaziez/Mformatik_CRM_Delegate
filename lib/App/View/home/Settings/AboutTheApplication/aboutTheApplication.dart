import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_bar.dart';

// ignore: must_be_immutable
class AboutTheApplication extends StatelessWidget {
  AboutTheApplication({super.key});
  TextEditingController controllerNote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "About the application".tr),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 251,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "app dec".tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Contact Us".tr),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/icons/X.png",
                      height: 28.39,
                      width: 32,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/icons/googleIcons.png",
                      height: 28.39,
                      width: 32,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/icons/linkideing.png",
                      height: 28.39,
                      width: 32,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
