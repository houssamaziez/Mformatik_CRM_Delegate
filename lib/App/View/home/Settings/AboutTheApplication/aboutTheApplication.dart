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
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.asset(
                  "assets/icons/about.png",
                  height: 150,
                ),
              ),
            ),
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
                    "We introduce an exclusive application designed for customer delegates, enabling them to effortlessly record their notes. This app facilitates the organization of information and the effective tracking of customer interactions, ultimately enhancing service quality and improving the overall customer experience."
                        .tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
