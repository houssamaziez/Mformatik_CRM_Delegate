import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';

import '../../../Controller/home/annex_controller.dart';
import '../../../Controller/home/company_controller.dart';
import '../../../Controller/home/home_controller.dart';
import '../../widgets/Containers/container_blue.dart';

class FilterCompany extends StatelessWidget {
  final HomeController controller;
  const FilterCompany({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height:
          controller.showContainers ? 165 : 0, // Adjust height based on toggle
      width: double.infinity,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: controller.showContainers
                ? 30
                : 0, // Adjust height based on toggle
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: "Select Annex".tr.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: controller.showContainers
                ? 50
                : 0, // Adjust height based on toggle
            width: double.infinity,
            child: GetBuilder<AnnexController>(
                init: AnnexController(),
                builder: (annexController) {
                  return annexController.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Annex found".tr,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // ignore: unnecessary_null_comparison
                          itemCount: annexController.annexList == null
                              ? 0
                              : annexController.annexList.length,
                          itemBuilder: (context, index) {
                            final annex = annexController.annexList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  annexController.updateannex(annex);
                                },
                                child: containerwithblue(context,
                                    color: annexController.selectAnnex != annex
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    backgColor:
                                        annexController.selectAnnex == annex
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                    widget: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Center(
                                          child: annex.label.style(
                                              color: annexController
                                                          .selectAnnex !=
                                                      annex
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white)),
                                    )),
                              ),
                            );
                          });
                }),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: controller.showContainers
                ? 30
                : 0, // Adjust height based on toggle
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: "Select Company".tr.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: controller.showContainers
                ? 50
                : 0, // Adjust height based on toggle
            width: double.infinity,
            child: GetBuilder<CompanyController>(
                init: CompanyController(),
                builder: (companyController) {
                  print('----------');

                  return companyController.isLoading.value ||
                          companyController.selectCompany == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Company found".tr,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: companyController.companies.length,
                          itemBuilder: (context, index) {
                            final company = companyController.companies[index];
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      companyController.updateannex(company);
                                    },
                                    child: containerwithblue(context,
                                        color:
                                            companyController.selectCompany !=
                                                    company
                                                ? Theme.of(context).primaryColor
                                                : Colors.white,
                                        backgColor:
                                            companyController.selectCompany ==
                                                    company
                                                ? Theme.of(context).primaryColor
                                                : Colors.white,
                                        widget: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: Center(
                                              child: company.label.style(
                                                  color: companyController
                                                              .selectCompany !=
                                                          company
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.white)),
                                        )),
                                  ),
                                ),
                                if (company.newMissionsCounts != 0)
                                  Positioned(
                                      right: 10,
                                      top: 5,
                                      child: Container(
                                        width: 13,
                                        height: 13,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(200)),
                                        child: Center(
                                          child: Text(
                                            company.newMissionsCounts! > 99
                                                ? 99.toString()
                                                : company.newMissionsCounts!
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                        ),
                                      ))
                              ],
                            );
                          });
                }),
          ),
        ],
      ),
    );
  }
}
